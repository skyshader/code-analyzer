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

  def readJson
    repo = params[:id]
    path = Rails.public_path + 'repos/' + repo
    file_path = File.join(path, 'result.json')
    puts file_path
    file = File.read(file_path)
    @data_hash = JSON.parse(file)

    @data_hash.each do |data|
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
      Thread.new(repo) do
        path = Rails.public_path + 'repos/' + repo
        Dir.chdir(path)
        # initialize codeclimate
        # session[:status] = 'Initializing config files'
        puts 'Initializing config files'
        # cmd = 'codeclimate init'
        # puts `#{cmd}`

        # run the analyzer
        # session[:status] = 'Analyzing repository'
        puts 'Analyzing repository'
        cmd = 'codeclimate analyze -f json'
        report_json = `#{cmd}`

        # puts report_json

        # store the data
        # session[:status] = 'Preparing reports'
        puts 'Saving results to database'
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

        # File.open("result.json","w") do |f|
        #   f.write(report_json)
        # end

        puts 'Completed processing'
      end
    end

end
