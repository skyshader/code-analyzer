class MainController < ApplicationController
  def index
  end

  # for testing purposes
  def test
    require 'find'
    @files_list = []
    ignore_dirs = ['.git']
    ignore_files = Regexp.union(/^\..*$/i, /^.*(.md)$/i)
    accepted_ext = ['.php']
    Find.find('/home/shaan/Sites/magento2/') do |path|
      path_name = File.basename(path)
      ext_name = File.extname(path_name)
      file_size = File.size(path)
      if FileTest.directory?(path)
        if ignore_dirs.include?(path_name)
          Find.prune
        else
          @files_list << {'path'=>path, 'is_directory'=>1}
        end
      else
        if path_name.match(ignore_files) or !accepted_ext.include?(ext_name)
          next
        else
          hash = Digest::SHA256.file(path).hexdigest
          @files_list << {'path'=>path, 'is_file'=>1, 'ext'=>ext_name, 'size'=>file_size, 'hash'=>hash}
        end
      end
      break if @files_list.size > 100

    end

    # @files_list.sort! { |x, y| x["size"] <=> y["size"] }
    # Thread.new do
    #   begin
    #     batches = batch_files @files_list
    #     phpmd batches
    #   rescue => e
    #     puts e.message + " ------ " + e.backtrace.to_s
    #   ensure
    #     puts 'Done processing batches'
    #   end
    # end
    # files.each_slice(size).to_a.each do |batch|

    # result = phpmd @files_list
    # render json: repo.authors.to_json
    # render :text => Rails.configuration.x.notify_url, :layout => true
    # render :text => "Processing batches!", :layout => true
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


  # generate activity + analyze -> in series
  def repo_process
    repo_id = params[:repo_id]
    type = params[:type]
    @status = Repository::Process.series(repo_id, type)
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

    def total_lines file
      line = `wc -l #{file.to_s}`
      line.strip.split(' ')[0].to_i
    end

    def batch_files files
      batched = []
      current_batch_index = 0
      current_batch_size = 0
      max_batch_size = 100000
      files.each do |file|
        if file['size'] <= 0
          next
        elsif file['size'] >= (max_batch_size - current_batch_size)
          current_batch_index += 1 if !batched[current_batch_index].nil?
          batched[current_batch_index] ||= []
          batched[current_batch_index] << file
          current_batch_size = file['size']
        elsif file['size'] < (max_batch_size - current_batch_size)
          batched[current_batch_index] ||= []
          batched[current_batch_index] << file
          current_batch_size += file['size']
        end
      end
      return batched
    end

    def phpmd batches
      batches.each do |batch|
        file_list = ""
        batch.each do |file|
          file_list += file['path'] + ","
        end
        file_list.chomp!(',')

        puts "Processing batch for " + file_list

        cmd = "phpmd " + file_list + " xml unusedcode,codesize,naming,cleancode,controversial,design"
        result = `#{cmd}`
        puts result
      end
    end

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
