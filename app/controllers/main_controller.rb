class MainController < ApplicationController
  def index
	end

  def process_url
    url = params[:url]
    process_repo(url)
  end

  def repo
    repo_id = params[:repo_id]
    type = params[:analysis_type]
    @status = begin_analysis(repo_id, type)
  end

  private
    # determine the type of analysis on the repo
    def begin_analysis(repo_id, type)
      repo = get_repo_to_process repo_id
      Thread.new do
        puts type + '//////////////////////////'
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
      # go to path - not accessible to public
      puts 'Creating directory'
      repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
      repo_path = Rails.root.join('storage', 'repos', repo.username, repo_name)
      FileUtils.mkdir_p(repo_path) unless File.directory?(repo_path)
      Dir.chdir(repo_path)
      repo.update(clone_path: repo_path)

      clone_repo repo
      puts '---- completed full analysis -------'
    rescue Exception => e
      repo.update(clone_path: nil)
      FileUtils.rm_rf(Rails.root.join('storage', 'repos', repo.username))
      puts '-- Failed full analysis --'
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

    # clone the requested repo
    def clone_repo repo
      set_status(repo, 1) {
        clone_cmd = 'git clone ' + repo.clone_url + ' ' + repo.default_branch
        clone_error = 'Not able to clone repository. Please make sure the repository exists.'
        system(clone_cmd)
        if $? != 0 then
          raise Exception.new(clone_error)
        end
      }
    end

    # initialize analysis config files
    def init_repo
      cmd = 'codeclimate init'
      puts `#{cmd}`
      # exclude unnecessary files in root
    end

    # begin analysis
    def analyze_repo
      cmd = 'codeclimate analyze -f json'
      report_json = `#{cmd}`
    end

    def store_data(data)
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
          :remediation_points=>data['remediation_points'] || nil
        )
        review.save

        # check for categories that exist
        data['categories'].each do |cat|
          code_category = CodeCategory.find_by name: cat
          if !code_category then
            code_category = CodeCategory.new(
              :name=>cat
            )
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

end