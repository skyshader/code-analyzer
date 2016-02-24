class MainController < ApplicationController
  def index
	end

  # for testing purposes
  def test
    # render json: repo.authors.to_json
    # render :text => Rails.configuration.x.notify_url, :layout => true
    render :text => "Get away, dude!", :layout => true
  end

  # generate activity + analyze -> in series
  def repo_process
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.series(repo_id, type)
    render json: @status
  end

  # for generating activity data
  def repo_activity
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.activity(repo_id, type)
    render json: @status
  end

  # for generating analysis reports
  def repo_analyze
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.analyze(repo_id, type)
    render json: @status
  end

  # for adding ssh keys to access private repos
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

    # not used yet
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
