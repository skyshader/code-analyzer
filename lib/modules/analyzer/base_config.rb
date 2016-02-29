module Analyzer

  ConfigFailureError = Class.new(StandardError)

  class BaseConfig

    # supported languages with their extensions
    LANGUAGES_SUPPORTED = {
      "php" => [".php", ".module", ".inc"],
      "javascript" => [".js", ".jsx"],
      "css" => [".css"]
    }.freeze


    # extract extensions from supported languages
    def ext_supported
      LANGUAGES_SUPPORTED.values.flatten
    end


    # common directories to avoid
    def dir_excluded
      ['.', '..', '.git', 'log', 'logs', 'tmp', 'temp']
    end


    # generate regex for commonly excluded file types
    # for ex: dot files, .md files
    def ext_excluded_regex
      Regexp.union(/^\..*$/i, /^.*(.md)$/i)
    end

  end

end