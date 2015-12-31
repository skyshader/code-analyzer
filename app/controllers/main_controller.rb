class MainController < ApplicationController
  def index
	end

  def process_url
    url = params[:url]
  end

  def repo
    repo_id = params[:repo_id]
    type = params[:analysis_type]
    @status = begin_analysis(repo_id, type)
  end

  def process_key
    username = params[:git_name]
    email = Base64.decode64(params[:email])
    if email.empty? || username.empty?
      @data = {'success'=>false, 'email'=>'Email/username not provided.'}
    else
      @data = generate_ssh(email, username)
    end
    render json: @data
  rescue RuntimeError => e
    @data = {'success'=>false, 'message'=>e.to_s}
    render json: @data
  end


  # start private methods
  private

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
    rescue RuntimeError => e
      msg = { :success => false, :message => "Failed to get repository!" }
    end

    # perform full analysis of the repo
    def full_analysis repo
      initial_path_setup repo
      clone_repo repo
      init_repo repo
      exclude_files repo
      report_json = analyze_repo repo
      store_data(report_json, repo)
      puts '---- completed full analysis -------'
    rescue RuntimeError => e
      repo.update(clone_path: nil)
      FileUtils.rm_rf(Rails.root.join('storage', 'repos', repo.username + '_' + repo.supplier_project_id))
      puts '-- Failed full analysis --'
    end

    # refresh the analysis for repo
    def refresh_analysis repo
      switch_repo_path repo
      # pull_repo repo
      # report_json = analyze_repo repo
      # store_data(report_json, repo)
      calculate_results repo
      puts 'Success refresh'
    rescue Exception => e
      puts 'Failed refresh' + e.to_s
    end

    # return the requested repo from db
    def get_repo_to_process(repo_id)
      repo = SupplierProjectRepo.find(repo_id)
    end

    # set status on basis of tasks
    def set_status(repo, status)
      yield
      repo.update(analysis_status: status, error_status: nil, error_message: nil)
    rescue RuntimeError => e
      repo.update(analysis_status: 0, error_status: status, error_message: e.to_s)
      raise
    end

    # initial setup for clone path
    def initial_path_setup repo
      repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
      repo_path = Rails.root.join('storage', 'repos', repo.username, repo.supplier_project_id.to_s, repo_name)
      FileUtils.mkdir_p(repo_path) unless File.directory?(repo_path)
      Dir.chdir(repo_path)
      repo.update(clone_path: repo_path)
    end

    # switch to repo path provided
    def switch_repo_path repo
      Dir.chdir(repo.clone_path + '/' + repo.current_branch)
    end

    # run pull command to get fresh repo
    def pull_repo repo
      set_status(repo, 6) {
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
        clone_url = repo.clone_url.clone
        # for private repo convert ssh url to use keys
        if repo.is_private === 1
          clone_url = clone_url.insert(clone_url.index(':'), "-" + repo.username)
        end
        clone_cmd = 'git clone ' + clone_url + ' ' + repo.default_branch
        system(clone_cmd)
        if $? != 0 then
          raise 'Failed to clone repository.'
        end
        Dir.chdir(repo.default_branch)
      }
    end

    # initialize analysis config files
    def init_repo repo
      set_status(repo, 2) {
        init_cmd = 'codeclimate init'
        system(init_cmd)
        if $? != 0 then
          raise 'Failed to initialize configuration.'
        end
      }
    end

    # exclude unnecessary files
    def exclude_files repo
      config = YAML.load_file('.codeclimate.yml')
      config["exclude_paths"] |= [".git/**/*", ".*", "**.md", "**.json", "**.yml", "**.log", "lib/**/*", "bin/**/*", "log/**/*", "vendor/**/*", "tmp/**/*", "assets/**/*", "test/**/*"]
      File.open('.codeclimate.yml', 'w') {|f| f.write config.to_yaml }
    end

    # begin analysis
    def analyze_repo repo
      set_status(repo, 3) {
        analyze_cmd = 'codeclimate analyze -f json'
        report_json = `#{analyze_cmd}`
        if $? != 0 then
          raise 'Failed to analyse repository.'
        end
       return report_json
      }
    end

    def store_data(report_json, repo)
      set_status(repo, 4) {
        # get rid of previous reviews
        CodeReview.destroy_all(supplier_project_repo_id: repo.id)
        data_hash = JSON.parse(report_json)
        data_hash.each do |data|
          # insert code review
          review = CodeReview.new(
            :issue_type=>data['type'],
            :check_name=>data['check_name'],
            :description=>data['description'],
            :engine_name=>data['engine_name'],
            :file_path=>data['location']['path'],
            :line_begin=>data['location']['lines']['begin'],
            :line_end=>data['location']['lines']['end'],
            :remediation_points=>data['remediation_points'] || nil,
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
      }
    end

    def calculate_results repo
      set_status(repo, 6) {
        files = files_to_analyze
        files = prepare_files_to_rate files
        files = count_total_lines files
        files = count_errors(files, repo)
        files = grade_categories files
        files = grade_files files
        puts files
        gpa = grade_repo files
        cat_issues = get_category_issues files
        store_cat_issues(repo, cat_issues)
        puts 'stored data'
      }
    end

    def files_to_analyze
      require 'find'
      ignore_dirs = ['.git','bin','assets','lib','log','vendor','tmp']
      ignore_files = Regexp.union(/^\..*$/i, /^.*(.md)$/i, /^.*(.json)$/i, /^.*(.yml)$/i, /^.*(.log)$/i)
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
        CodeCategory.find_each do |category|
          f[file]['categories'] = f[file]['categories'].merge({category.name => {}})
          f[file]['categories'][category.name] = f[file]['categories'][category.name].merge({'total_errors'=>0, 'lines_with_error'=>0, 'weight'=>category.weight})
        end
      end
      return f
    end

    def count_total_lines files
      files.each do |f, k|
        lines_output = `wc -l #{f.to_s}`
        if $? != 0 then
          raise Exception.new('Error in counting total lines.')
        end
        lines_count = lines_output.strip.split(' ')[0].to_i
        k['total_lines'] = lines_count
      end
      return files
    end

    def count_errors(files, repo)
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
      CodeCategory.find_each do |category|
        total_weight += category.weight
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
        repo_grade += file_grade
      end
      return repo_grade.round(1)
    end

    def get_category_issues files
      cat_issues = {}
      CodeCategory.find_each do |category|
        cat_issues = cat_issues.merge({category.name => {'count' => 0, 'id' => category.id}})
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
        cat_stat = RepoCategoryStat.where("supplier_project_repo_id = #{repo.id} AND code_category_id = #{issue[1]['id']}")
        if cat_stat.empty?
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
