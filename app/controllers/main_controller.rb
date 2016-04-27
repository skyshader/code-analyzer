class MainController < ApplicationController
  
  before_action :queue_request, only: [:analyze, :activity]

  # for testing purposes
  def index
    # render :text => Rails.configuration.x.notify_url, :layout => true
    render :text => "Write code to test here!", :layout => true
  end


  # setup repository, create essential entries and configuration
  def setup
    data = params[:repository].symbolize_keys
    ActiveRecord::Base.connection_pool.with_connection do
      Repository.transaction do
        @repository = Repository.create_repository data
        @branch = Branch.setup_branch @repository
      end
    end

    @status = Bootstrap::Setup.new(
      repository: @repository,
      branch: @branch
    ).configure

    render json: @status
  end


  # for generating activity data
  def activity
    data = params[:repository].symbolize_keys
    @status = Activity::Process.run data
    render json: @status
  end


  # for generating analysis reports
  def analyze
    data = params[:repository].symbolize_keys
    @status = Analyzer::Process.run data
    render json: @status
  end


  # for adding ssh keys to access private repos
  def ssh
    data = params[:ssh].symbolize_keys
    username, email, host = data[:username], data[:email], data[:host]
    @data = Utility::SSHKey.generate(username, email, host)
    render json: @data
  rescue => e
    @data = {'success'=>false, 'message'=>e.to_s}
    render json: @data
  end


  def queue_request
    data = params[:repository].symbolize_keys
    result = Utility::RequestHandler.run(action_name, data)
    render json: result if result[:status] === 2
  end

end
