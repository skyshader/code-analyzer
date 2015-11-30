class MainController < ApplicationController
  def index
	end

  def processUrl
    url = params[:url]
    processRepo(url)
  end

  def repo
    repo = params[:id]
    startAnalysis(repo)
  end

  private
    def processRepo(url)
      Thread.new do
        # clone the repository
        session[:status] = 'Cloning the repository'
        cmd = 'git clone ' + url
        path = Rails.public_path + 'repos/'
        Dir.chdir(path){
          puts `#{cmd}`
        }
      end
    end

    def startAnalysis(repo)
      path = Rails.public_path + 'repos/' + repo
      Dir.chdir(path)
      Thread.new do
        # initialize codeclimate
        # session[:status] = 'Initializing config files'
        puts 'Initializing config files'
        cmd = 'codeclimate init'
        puts `#{cmd}`

        # run the analyzer
        # session[:status] = 'Analyzing repository'
        puts 'Analyzing repository'
        cmd = 'codeclimate analyze -f json'
        report_json = `#{cmd}`

        # store the data
        # session[:status] = 'Preparing reports'
        puts report_json
      end
    end

end
