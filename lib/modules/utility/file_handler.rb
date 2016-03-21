module Utility

  FileHandlerFailureError = Class.new(StandardError)

  class FileHandler

    attr_reader :repository, :branch, :directory, :all_files, :existing_files, :difference, :analyzer_config

    MAX_BATCH_SIZE = 100000
    MAX_BATCH_FILES = 10
    MAX_CODE_LIMIT_ONE_LINE = 500
    MAX_CODE_LIMIT_GROUP = 100


    def initialize(repository:, branch:)
      @repository = repository
      @directory = repository.directory
      @branch = branch
      @analyzer_config = Analyzer::BaseConfig.new
      @languages = {}
    end


    def self.extract_source_code file, from, to
      file = File.open(file)
      code = ""
      (from.to_i - 1).times { file.gets }
      (to.to_i - (from.to_i - 1)).times do |i|
        line = file.gets
        code += line.truncate(MAX_CODE_LIMIT_ONE_LINE) if line
        break if i >= MAX_CODE_LIMIT_GROUP
      end
      file.close
      code.force_encoding('iso-8859-1').encode('utf-8')
    end


    # list files that can be analyzed
    def list_files
      require 'find'
      @all_files = []
      Find.find(@directory.to_s + "/") do |path|
        if FileTest.directory?(path)
          if @analyzer_config.dir_excluded.include?(File.basename(path).downcase)
            Find.prune
          else
            file_info = get_file_info path
            @all_files << file_info
          end
        else
          if !@analyzer_config.ext_supported.include?(File.extname(path).downcase)
            next
          else
            file_info = get_file_info path
            @all_files << file_info
          end
        end
      end
      self
    rescue => e
      raise FileHandlerFailureError, "Failed to list directory! -> " + e.message
    end


    # group files based on extensions
    def grouped_file_batches
      file_groups = FileList.get_files_to_process(@branch)
      .group_by { |file| get_language(file) }
      create_batches file_groups
    end


    # group new, changed and unchanged files
    def diff_files
      @existing_files = FileList.get_file_lists @branch
      @difference = generate_diff
      self
    rescue => e
      raise FileHandlerFailureError, "Failed to calculate directory difference! -> " + e.message
    end


    def save
      FileList.update_files_status @difference[:changed]
      FileList.create_file_lists @difference[:new]
    rescue => e
      raise FileHandlerFailureError, "Failed to update file listing! -> " + e.message
    end


    private

    def get_file_info path
      is_directory = FileTest.directory?(path)
      cloc = get_cloc_stats(path, is_directory)
      {
        name: File.basename(path),
        is_file:  is_directory ? 0 : 1,
        extension: is_directory ? nil : File.extname(path),
        file_size: File.size(path).to_s,
        phash: Digest::SHA256.hexdigest(path),
        fhash: is_directory ? nil : Digest::SHA256.file(path).hexdigest,
        relative_path: project_relative_path(path),
        parent_path: parent_path(path),
        full_path: path,
        lines_blank: cloc[:lines_blank],
        lines_comment: cloc[:lines_comment],
        lines_code: cloc[:lines_code],
        supported_language_id: is_directory ? nil : file_language(File.extname(path)),
        branch_id: @branch.id
      }
    end

    def get_cloc_stats path, is_directory
      file = nil
      if !is_directory
        result = `cloc "#{path}" --xml --by-file --quiet`
        require 'nokogiri'
        file = Nokogiri::XML(result).xpath("//files/file").first
      end
      {
        lines_blank: file ? file['blank'] : nil,
        lines_comment: file ? file['comment'] : nil,
        lines_code: file ? file['code'] : nil
      }
    end

    
    def file_language ext
      language = nil
      Analyzer::BaseConfig::LANGUAGES_SUPPORTED.each do |k, v|
        language = k if v.include?(ext)
      end
      return language unless language
      ActiveRecord::Base.connection_pool.with_connection do
        @languages[language] ||= SupportedLanguage.where(name: language).first.id
      end
    end

    
    def get_language file
      ActiveRecord::Base.connection_pool.with_connection do
        @languages[file.supported_language_id] ||= file.supported_language.name
      end
    end


    def project_relative_path full_path
      relative_path = full_path.gsub(@directory.to_s, '')
    end

    
    def parent_path full_path
      relative_path = project_relative_path(full_path)
      return nil if relative_path.eql? '/'
      parent_path = relative_path.gsub(File.basename(full_path), '')
      parent_path = parent_path.chomp('/') if !parent_path.eql? '/'
      parent_path
    end


    # separate files
    # that have changed,
    # not changed and
    # are newly added
    def generate_diff
      files = {
        :new => [],
        :unchanged => [],
        :changed => []
      }

      existing_phashes = files_to_phash @existing_files
      current_phashes = files_to_phash @all_files

      @all_files.each do |file|
        files[:new] << file if !existing_phashes.include?(file[:phash])
        files[:unchanged] << file if existing_phashes.include?(file[:phash])
      end

      @existing_files.each do |file|
        files[:changed] << file if !current_phashes.include?(file[:phash])
      end
      files
    end


    def create_batches files_groups
      batch = {}
      files_groups.each do |key, files|
        current_batch_index = 0
        current_batch_size = 0
        current_batch_files = 0
        batch[key] = []
        batch[key][current_batch_index] ||= []
        files.each do |file|
          if file.file_size < (MAX_BATCH_SIZE - current_batch_size) && current_batch_files < MAX_BATCH_FILES
            batch[key][current_batch_index] << file
            current_batch_size += file.file_size
            current_batch_files += 1
          else
            current_batch_index += 1
            batch[key][current_batch_index] ||= []
            batch[key][current_batch_index] << file
            current_batch_size = file.file_size
            current_batch_files = 1
          end
        end
      end
      return batch
    end


    def files_to_phash files
      files.map() { |h| h[:phash] }
    end

  end
end