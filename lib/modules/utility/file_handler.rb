module Utility

  FileHandlerFailureError = Class.new(StandardError)

  class FileHandler

    def initialize(repository:, directory:, base_config:)
      @repository = repository
      @directory = directory
      @base_config = base_config
    end

    # list files that can be analyzed
    def list_files
      require 'find'
      @dir_structure = []
      Find.find(@directory.to_s + "/") do |path|
        file_info = get_file_info path
        if FileTest.directory?(path)
          if @base_config.dir_excluded.include?(file_info[:path_name])
            Find.prune
          else
            @dir_structure << file_info
          end
        else
          if !@base_config.ext_supported.include?(file_info[:ext_name])
            next
          else
            @dir_structure << file_info
          end
        end
      end

      puts @dir_structure.to_s
    end

    private

    attr_reader :repository, :directory, :base_config

    def get_file_info path
      is_directory = FileTest.directory?(path)
      {
        :path_name => File.basename(path),
        :is_file =>  is_directory ? 0 : 1,
        :ext_name => is_directory ? nil : File.extname(path),
        :file_size => File.size(path),
        :file_path => path,
        :path_hash => Digest::SHA256.hexdigest(path),
        :file_hash => is_directory ? nil : Digest::SHA256.file(path).hexdigest,
        :relative_path => project_relative_path(path)
      }
    end

    def project_relative_path full_path
      relative_path = full_path.gsub(@directory.to_s, '')
      # relative_path = relative_path.gsub(/^\//, '') if !relative_path.eql? "/"
    end

  end
end