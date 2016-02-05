class MainController < ApplicationController
  def index
	end

  def test
    render :text => Rails.configuration.x.notify_url, :layout => true
  end

  def repo
    repo_id = params[:repo_id]
    type = params[:analysis_type]
    logger.debug "Going to start " + type + " analysis for " + repo_id.to_s
    @status = begin_analysis(repo_id, type)
    render json: @status
  end

  def process_key
    username = params[:git_name]
    email = Base64.decode64(params[:email])
    if email.empty? || username.empty?
      @data = {'success'=>false, 'email'=>'Email/username not provided.'}
    else
      @data = generate_ssh(email, username)
    end
    puts @data.to_s
    render json: @data
  rescue => e
    @data = {'success'=>false, 'message'=>e.to_s}
    render json: @data
  end

  def activate_key
    username = params[:git_name]
    ssh_key_activate username
    @data = {'success'=>true, 'msg'=>'SSH Key verified successfully!'}
    render json: @data
  end


  # start private methods
  private

    # activate key by requesting github
    def ssh_key_activate username
      # ssh_cmd = "sh " + ENV['HOME'] + "/activate-ssh.sh " + username
      # ssh_cmd = "ssh -T git@github.com-" + username
      # logger.debug "SSH Command : " + ssh_cmd
      # system(ssh_cmd)
    end

    # generate ssh keys for accessing users private repo
    def generate_ssh(email, username)
      ssh_file = ENV['HOME'] + '/.ssh/id_rsa_' + username
      key_exist = ssh_key_exist ssh_file
      if !key_exist
        ssh_keygen(email, ssh_file)
        ssh_modify_config(username, ssh_file)
      end
      public_key = ssh_public_key ssh_file
      data = {'success'=>true, 'public_key'=>public_key, 'email'=>email}
      return data
    end

    # check if ssh key already exist
    def ssh_key_exist ssh_file
      if File.file?(ssh_file)
        return true
      else
        return false
      end
    end

    # generate new ssh key
    def ssh_keygen(email, ssh_file)
      genssh_cmd = "ssh-keygen -t rsa -C '#{email}' -f '#{ssh_file}' -N ''"
      system(genssh_cmd)
      if $? != 0 then
        raise 'Failed to generate ssh key.'
      end
      return ssh_file
    end

    # add details to ssh config
    def ssh_modify_config(username, ssh_file)
      config_path = verify_config
      File.open(config_path, 'a') do |f|
        f.puts("##{username} account")
        f.puts("Host github.com-#{username}")
        f.puts("    HostName github.com")
        f.puts("    User git")
        f.puts("    IdentityFile #{ssh_file}")
        f.puts("    IdentitiesOnly yes")
        f.puts("")
      end
    end

    # if ssh config file does not exist, create one
    def verify_config
      config_path = ENV['HOME'] + '/.ssh/config'
      if !File.file?(config_path)
        create_config_cmd = "touch #{config_path}"
        system(create_config_cmd)
        if $? != 0 then
          raise 'Failed to create config file.'
        end
      end
      return config_path
    end

    # return public ssh key
    def ssh_public_key ssh_file
      return File.read(ssh_file + '.pub')
    end

    # determine the type of analysis on the repo
    def begin_analysis(repo_id, type)
      repo = get_repo_to_process repo_id
      Thread.new do
        if type == 'full'
          full_analysis repo
        elsif type == 'refresh'
          refresh_analysis repo
        end
      end
      msg = { :success => true, :message => "Please wait while we process the repository!" }
    rescue => e
      msg = { :success => false, :message => "Failed to get repository! " + e.to_s }
    end

    # perform full analysis of the repo
    def full_analysis repo
      initial_path_setup repo
      logger.debug "01 - Done setting up initial path - LOG"
      clone_repo repo
      logger.debug "02 - Done cloning the repo - LOG"
      init_repo repo
      logger.debug "03 - Done initializing codeclimat config - LOG"
      exclude_files repo
      logger.debug "04 - Done excludiing files - LOG"
      report_json = analyze_repo repo
      logger.debug "05 - Done analyzing repository - LOG"
      store_data(report_json, repo)
      logger.debug "06 - Done storing data - LOG"
      calculate_results repo
      logger.debug "07 - Done calculating result - LOG"
    rescue => e
      ActiveRecord::Base.connection_pool.with_connection do 
        repo.update(clone_path: nil)
        repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
        FileUtils.rm_rf(Rails.root.join('storage', 'repos', repo.username, repo.supplier_project_id.to_s, repo_name, repo.current_branch))
      end
    end

    # refresh the analysis for repo
    def refresh_analysis repo
      switch_repo_path repo
      logger.debug "01 - Done switching up initial path - LOG"
      pull_repo repo
      logger.debug "02 - Done pulling fresh repository - LOG"
      report_json = analyze_repo repo
      logger.debug "03 - Done analyzing repository - LOG"
      store_data(report_json, repo)
      logger.debug "04 - Done storing data - LOG"
      calculate_results repo
      logger.debug "05 - Done calculating results - LOG"
    rescue
      raise
    end

    # return the requested repo from db
    def get_repo_to_process(repo_id)
      ActiveRecord::Base.connection_pool.with_connection do 
        repo = SupplierProjectRepo.find(repo_id)
      end
    end

    # set status on basis of tasks
    def set_status(repo, status)
      yield
      ActiveRecord::Base.connection_pool.with_connection do 
        repo.update(analysis_status: status, error_status: nil, error_message: nil)
      end
    rescue => e
      ActiveRecord::Base.connection_pool.with_connection do 
        repo.update(analysis_status: 0, error_status: status, error_message: e.to_s)
      end
      logger.debug "Exception at status " + status.to_s + " : " + e.message + " --- " + e.backtrace.to_s
      raise
    ensure
      # call to request url
      # request_url(repo, status, caller_locations(2,2)[0].label)
    end

    # initial setup for clone path
    def initial_path_setup repo
      repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
      repo_path = Rails.root.join('storage', 'repos', repo.username, repo.supplier_project_id.to_s, repo_name)
      FileUtils.mkdir_p(repo_path) unless File.directory?(repo_path)
      Dir.chdir(repo_path)
      ActiveRecord::Base.connection_pool.with_connection do 
        repo.update(clone_path: repo_path)
      end
    end

    # switch to repo path provided
    def switch_repo_path repo
      Dir.chdir(repo.clone_path + '/' + repo.current_branch)
    end

    # run pull command to get fresh repo
    def pull_repo repo
      set_status(repo, 2) {
        pull_cmd = 'git checkout ' + repo.current_branch + ' & git pull origin ' + repo.current_branch;
        system(pull_cmd)
        if $? != 0 then
          raise 'Not able to pull from repository.'
        end
      }
    end

    # clone the requested repo
    def clone_repo repo
      set_status(repo, 1) {
        # empty directory before clone
        repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
        FileUtils.rm_rf(Rails.root.join('storage', 'repos', repo.username, repo.supplier_project_id.to_s, repo_name, repo.current_branch))

        clone_url = repo.clone_url.clone
        # for private repo convert ssh url to use keys
        if repo.is_private === 1
          clone_url = clone_url.insert(clone_url.index(':'), "-" + repo.username)
       end
        clone_cmd = 'git clone ' + clone_url + ' ' + repo.current_branch
        system(clone_cmd)
        if $? != 0 then
          raise 'Failed to clone repository.'
        end
        Dir.chdir(repo.current_branch)
      }
    end

    # initialize analysis config files
    def init_repo repo
      set_status(repo, 2) {
        init_cmd = 'codeclimate init'
        init_result = `#{init_cmd}`
        # if $? != 0 then
        #   raise 'Failed to initialize configuration.'
        # end
      }
    end

    # exclude unnecessary files
    def exclude_files repo
      config = YAML.load_file('.codeclimate.yml')
      config["exclude_paths"] |= [".git/**/*", ".*", "**.md", "**.json", "**.yml", "**.log", "lib/**/*", "bin/**/*", "log/**/*", "vendor/**/*", "tmp/**/*", "assets/**/*", "test/**/*", "uploads/**/*", "img/**/*", "images/**/*", "fonts/**/*"]
      File.open('.codeclimate.yml', 'w') {|f| f.write config.to_yaml }
    end

    # begin analysis
    def analyze_repo repo
      set_status(repo, 3) {
        analyze_cmd = 'codeclimate analyze -f json'
        logger.debug "Running analysis command : " + analyze_cmd
        report_json = `#{analyze_cmd}`
        logger.debug "Analysis report ----" + report_json.to_s
        # if $? != 0 then
        #   raise 'Failed to analyse repository.'
        # end
       return report_json
      }
    end

    def store_data(report_json, repo)
      set_status(repo, 4) {
        ActiveRecord::Base.connection_pool.with_connection do 
          # get rid of previous reviews
          CodeReview.destroy_all(supplier_project_repo_id: repo.id)
          data_hash = JSON.parse(report_json)
          data_hash.each do |data|
            begin_line = data['location']['lines'] ? data['location']['lines']['begin'] : data['location']['positions']['begin']['line']
            end_line = data['location']['lines'] ? data['location']['lines']['end'] : data['location']['positions']['end']['line']
            # insert code review
            review = CodeReview.new(
              :issue_type=>data['type'],
              :check_name=>data['check_name'],
              :description=>data['description'],
              :engine_name=>data['engine_name'],
              :file_path=>data['location']['path'],
              :line_begin=>begin_line,
              :line_end=>end_line,
              :remediation_points=>data['remediation_points'] || nil,
              :content=>data['content'] ? data['content']['body'] : nil,
              :supplier_project_repo_id=>repo.id
            )
            review.save

            # check for categories that exist
            data['categories'].each do |cat|
              code_category = CodeCategory.find_by name: cat
              if !code_category then
                code_category = CodeCategory.new(:name=>cat, :weight=>10)
                code_category.save
              end

              # save reviews categories
              code_review_category = CodeReviewCategory.new(
                :name=>code_category.name,
                :code_category_id=>code_category.id,
                :code_review_id=>review.id
              )
              code_review_category.save
            end
          end
        end
      }
    end

    def calculate_results repo
      set_status(repo, 5) {
        files = files_to_analyze
        puts '-----Files to analyze done (Step 1)'
        files = prepare_files_to_rate files
        puts '-----Prepare files to rate done (Step 2)'
        files = count_total_lines files
        puts '-----Count total lines done (Step 3)'
        files = count_errors(files, repo)
        puts '-----Count errors done (Step 4)'
        files = grade_categories files
        puts '-----Grade categories done (Step 5)'
        files = grade_files files
        puts '-----Grade files done (Step 6)' + files.to_s
        gpa = grade_repo files
        puts '-----Grade repos done (Step 7)' + gpa.to_s
        gpa_percent = get_overall_grades files
        puts '-----Grade overall percentage done (Step 8)' + gpa_percent.to_s
        cat_issues = get_category_issues files
        puts '-----Get categories issues done (Step 9)' + cat_issues.to_s
        store_cat_issues(repo, cat_issues)
        puts '-----Store category issues done (Step 10)'
        store_grades(repo, gpa, gpa_percent)
        puts '-----Store grades done (Step 11)'
      }
    end

    def files_to_analyze
      require 'find'
      ignore_dirs = ['.git','bin','test','assets','lib','log','vendor','tmp','img', 'images', 'uploads', 'fonts']
      ignore_files = Regexp.union(/^\..*$/i, /^.*(.md)$/i, /^.*(.json)$/i, /^.*(.yml)$/i, /^.*(.log)$/i, /^.*(.png)$/i, /^.*(.jpg)$/i, /^.*(.jpeg)$/i)
      final_files = []
      # for every file in repository - keep the files to process
      Find.find('.') do |path|
        path_name = File.basename(path)
        if FileTest.directory?(path)
          if ignore_dirs.include?(path_name)
            Find.prune
          else
            next
          end
        else
          if path_name.match(ignore_files)
            next
          else
            path.gsub!(/^\.\//, '')
            final_files.push(path)
          end
        end
      end
      return final_files
    end

    def prepare_files_to_rate files
      f = {}
      files.each do |file|
        f[file] = {'total_lines'=>0, 'lines_with_error'=>0, 'total_errors'=>0}
        f[file]['categories'] = {}
        ActiveRecord::Base.connection_pool.with_connection do 
          CodeCategory.find_each do |category|
            f[file]['categories'] = f[file]['categories'].merge({category.name => {}})
            f[file]['categories'][category.name] = f[file]['categories'][category.name].merge({'total_errors'=>0, 'lines_with_error'=>0, 'weight'=>category.weight})
          end
        end
      end
      return f
    end

    def count_total_lines files
      files.each do |f, k|
        lines_output = `wc -l #{f.to_s}`
        if $? != 0 then
          raise 'Error in counting total lines.'
        end
        lines_count = lines_output.strip.split(' ')[0].to_i
        k['total_lines'] = lines_count
      end
      return files
    end

    def count_errors(files, repo)
      ActiveRecord::Base.connection_pool.with_connection do 
        repo.code_review.each do |review|
          if files.has_key?(review.file_path)
            files[review.file_path]['total_errors'] += 1
            error_lines = (review.line_end - review.line_begin) + 1
            files[review.file_path]['lines_with_error'] += error_lines
            review.code_category.each do |category|
              files[review.file_path]['categories'][category.name]['total_errors'] += 1
              files[review.file_path]['categories'][category.name]['lines_with_error'] += error_lines
            end
          end
        end
      end
      return files
    end

    def grade_categories files
      files.each do |f|
        f[1]['categories'].each do |cat|
          safe_lines = f[1]['total_lines'] - cat[1]['lines_with_error']
          if safe_lines < 0
            safe_lines = 0
          end
          cat_grade = (safe_lines.to_f / f[1]['total_lines'].to_f) * 4
          cat[1] = cat[1].merge({'grade'=>cat_grade.round(1)})
          files[f[0]]['categories'][cat[0]] = cat[1]
        end
      end
      return files
    end

    def grade_files files
      total_weight = 0
      ActiveRecord::Base.connection_pool.with_connection do 
        CodeCategory.find_each do |category|
          total_weight += category.weight
        end
      end
      files.each do |f|
        grade = 0
        f[1]['categories'].each do |cat|
          grade += (cat[1]['grade'].to_f * ((cat[1]['weight'].to_f / total_weight.to_f)))
        end
        files[f[0]] = f[1].merge({'grade'=>grade.round(1)})
      end
      return files
    end

    def grade_repo files
      total_lines = 0
      files.each do |f|
        total_lines += f[1]['total_lines']
      end
      repo_grade = 0
      files.each do |f|
        file_grade = (f[1]['total_lines'] / total_lines.to_f) * f[1]['grade']
        next if file_grade.nan?
        repo_grade += file_grade
      end
      return repo_grade.round(1)
    end

    def get_category_issues files
      cat_issues = {}
      ActiveRecord::Base.connection_pool.with_connection do 
        CodeCategory.find_each do |category|
          cat_issues = cat_issues.merge({category.name => {'count' => 0, 'id' => category.id}})
        end
      end
      files.each do |f|
        f[1]['categories'].each do |cat|
          cat_issues[cat[0]]['count'] += cat[1]['total_errors']
        end
      end
      return cat_issues
    end

    def store_cat_issues(repo, cat_issues)
      cat_issues.each do |issue|
        ActiveRecord::Base.connection_pool.with_connection do 
          cat_stat = RepoCategoryStat.find_by supplier_project_repo_id: repo.id, code_category_id: issue[1]['id']
          if !cat_stat
            cat_stat = RepoCategoryStat.new
          end
          cat_stat.issues_count = issue[1]['count']
          cat_stat.version = 1
          cat_stat.supplier_project_repo_id = repo.id
          cat_stat.code_category_id = issue[1]['id']
          cat_stat.save
        end
      end
    end

    def get_overall_grades files
      total_files = 0
      grade_count = {'A'=>0, 'B'=>0, 'C'=>0, 'D'=>0, 'F'=>0}
      files.each do |f|
        total_files += 1
        if f[1]['grade'] >= 3.5 and f[1]['grade'] <= 4.0
          grade_count['A'] += 1
        elsif f[1]['grade'] >= 2.5 and f[1]['grade'] < 3.5
          grade_count['B'] += 1
        elsif f[1]['grade'] >= 1.5 and f[1]['grade'] < 2.5
          grade_count['C'] += 1
        elsif f[1]['grade'] >= 0.5 and f[1]['grade'] < 1.5
          grade_count['D'] += 1
        elsif f[1]['grade'] >= 0 and f[1]['grade'] < 0.5
            grade_count['F'] += 1
        end
        # if f[1]['grade'].between?(3.5, 4.0)
        #   grade_count['A'] += 1
        # elsif f[1]['grade'].between?(2.5, 3.5)
        #   grade_count['B'] += 1
        # elsif f[1]['grade'].between?(1.5, 2.5)
        #   grade_count['C'] += 1
        # elsif f[1]['grade'].between?(0.5, 1.5)
        #   grade_count['D'] += 1
        # elsif f[1]['grade'].between?(0, 0.5)
        #   grade_count['F'] += 1
        # end
      end
      grade_count.each do |g|
        grade_count[g[0]] = ((g[1]/total_files.to_f) * 100).round(2)
      end
      return grade_count
    end

    def store_grades(repo, gpa, gpa_percent)
      ActiveRecord::Base.connection_pool.with_connection do 
        gpa_percent = gpa_percent.merge({'gpa'=>gpa})
        gpa_percent = gpa_percent.to_json
        repo.update(gpa: gpa_percent)
      end
    end

    def request_url(repo, status, call_type)
      uri = URI.parse(Rails.configuration.x.notify_url)
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({"Analyzer[repo_id]" => repo.id, "Analyzer[status]" => status, "Analyzer[type]" => call_type})
      response = http.request(request)
      puts response.body.to_s
    rescue => e
      puts e.message
    end

end
