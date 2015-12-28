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


  # start private methods
  private

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
    rescue
      msg = { :success => false, :message => "Failed to get repository!" }
    end

    def full_analysis repo
      initial_path_setup repo
      clone_repo repo
      init_repo repo
      exclude_files repo
      report_json = analyze_repo repo
      store_data(report_json, repo)
      puts '---- completed full analysis -------'
    rescue Exception => e
      repo.update(clone_path: nil)
      FileUtils.rm_rf(Rails.root.join('storage', 'repos', repo.username + '_' + repo.supplier_project_id))
      puts '-- Failed full analysis --'
    end

    def refresh_analysis repo
      switch_repo_path repo
      pull_repo repo
      calculate_results repo
      puts 'Success refresh'
    rescue
      puts 'Failed refresh'
    end

    # return the requested repo from db
    def get_repo_to_process(repo_id)
      repo = SupplierProjectRepo.find(repo_id)
    end

    # set status on basis of tasks
    def set_status(repo, status)
      yield
      repo.update(analysis_status: status, error_status: nil, error_message: nil)
    rescue Exception => e
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
          raise Exception.new('Not able to pull from repository.')
        end
      }
    end

    # clone the requested repo
    def clone_repo repo
      set_status(repo, 1) {
        clone_cmd = 'git clone ' + repo.clone_url + ' ' + repo.default_branch
        system(clone_cmd)
        if $? != 0 then
          raise Exception.new('Failed to clone repository.')
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
          raise Exception.new('Failed to initialize configuration.')
        end
      }
    end

    # exclude unnecessary files
    def exclude_files repo
      config = YAML.load_file('.codeclimate.yml')
      config["exclude_paths"] |= [".git/**/*", ".*", "**.md", "**.json", "**.yml", "**.log", "lib/**/*", "bin/**/*", "log/**/*", "vendor/**/*", "tmp/**/*", "assets/**/*"]
      File.open('.codeclimate.yml', 'w') {|f| f.write config.to_yaml }
    end

    # begin analysis
    def analyze_repo repo
      set_status(repo, 3) {
        analyze_cmd = 'codeclimate analyze -f json'
        report_json = `#{analyze_cmd}`
        if $? != 0 then
          raise Exception.new('Failed to analyse repository.')
        end
       return report_json
      }
    end

    def store_data(report_json, repo)
      set_status(repo, 4) {
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
        files_hash = prepare_files_to_rate files
        files_hash = count_total_lines files_hash
        files_hash = count_errors(files_hash, repo)
        
        puts files_hash
      }
    end

    def files_to_analyze
      require 'find'
      ignore_dirs = ['.git','test','bin','assets','lib','log','vendor','tmp']
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
          f[file]['categories'] = f[file]['categories'].merge({category.name => 0})
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
            files[review.file_path]['categories'][category.name] += 1
          end
        end
      end
      return files
    end

end
