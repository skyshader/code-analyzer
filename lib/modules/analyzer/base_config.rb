module Analyzer

  ConfigFailureError = Class.new(StandardError)

  class BaseConfig

    # supported languages with their extensions
    LANGUAGES_SUPPORTED = {
      "php" => [".php"],
      "javascript" => [".js", ".jsx"],
      "css" => [".css"]
    }.freeze

    ENGINES = {
      "php" => ["phpcs_engine", "phpmd_engine"],
      "javascript" => ["eslint_engine"],
      "css" => ["csslint_engine"]
    }.freeze


    # extract extensions from supported languages
    def ext_supported
      LANGUAGES_SUPPORTED.values.flatten
    end

    # extract available engines
    def available_engines
      ENGINES.values.flatten
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