class MainController < ApplicationController
  def index
	end

  def test
    repo = GitStats::GitData::Repo.new(path: ENV['HOME'] + '/Sites/code-analyzer-test', first_commit_sha: nil, last_commit_sha: 'HEAD')
    @data  = repo.commits
    # render json: repo.authors.to_json
    # render :text => Rails.configuration.x.notify_url, :layout => true
  end

  def repo_process
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.series(repo_id, type)
    render json: @status
  end

  def repo_activity
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.activity(repo_id, type)
    render json: @status
  end

  def repo_analyze_new
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.analyze(repo_id, type)
    render json: @status
  end

  def repo_analyze
    repo_id = params[:repo_id]
    type = params[:type]
    logger.debug "Going to start " + type + " analysis for " + repo_id.to_s
    @status = begin_analysis(repo_id, type)
    render json: @status
  end

  def key_generate
    username = params[:username]
    email = Base64.decode64(params[:email])
    host = Base64.decode64(params[:host])
    @data = Repository::SSHKey.generate(username, email, host)
    render json: @data
  rescue => e
    @data = {'success'=>false, 'message'=>e.to_s}
    render json: @data
  end

  # start private methods
  private

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
