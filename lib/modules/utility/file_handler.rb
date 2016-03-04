module Utility

  FileHandlerFailureError = Class.new(StandardError)

  class FileHandler

    attr_reader :all_files, :existing_files, :difference

    def initialize(repository:, directory:, branch:, base_config:)
      @repository = repository
      @directory = directory
      @branch = branch
      @base_config = base_config
    end


    # list files that can be analyzed
    def list_files
      require 'find'
      @all_files = []
      Find.find(@directory.to_s + "/") do |path|
        file_info = get_file_info path
        if FileTest.directory?(path)
          if @base_config.dir_excluded.include?(file_info[:name])
            Find.prune
          end
        else
          if !@base_config.ext_supported.include?(file_info[:extension])
            next
          end
        end
        @all_files << file_info
      end
      self
    rescue => e
      raise FileHandlerFailureError, "Failed to list directory! -> " + e.message
    end


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


    def group_files files
      
    end


    private

    attr_reader :repository, :directory, :base_config

    def get_file_info path
      is_directory = FileTest.directory?(path)
      {
        :name => File.basename(path),
        :is_file =>  is_directory ? 0 : 1,
        :extension => is_directory ? nil : File.extname(path),
        :file_size => File.size(path).to_s,
        :phash => Digest::SHA256.hexdigest(path),
        :fhash => is_directory ? nil : Digest::SHA256.file(path).hexdigest,
        :relative_path => project_relative_path(path),
        :parent_path => parent_path(path),
        :full_path => path,
        :branch => @branch
      }
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
    # that have changed, not changed and are new
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

    def files_to_phash files
      files.map() { |h| h[:phash] }
    end

  end
end