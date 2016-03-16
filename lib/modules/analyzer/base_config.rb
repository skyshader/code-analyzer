module Analyzer

  ConfigFailureError = Class.new(StandardError)

  class BaseConfig

    # supported languages with their extensions
    LANGUAGES_SUPPORTED = {
      php: [".php"],
      javascript: [".js", ".jsx"],
      css: [".css"]
    }.freeze

    # available engines for languages
    ENGINES = {
      php: [
        ::Analyzer::Engines::PHP::CodeSniffer::Engine,
        ::Analyzer::Engines::PHP::MessDetector::Engine
      ],
      javascript: [
        ::Analyzer::Engines::Javascript::Engine
      ],
      css: [
        ::Analyzer::Engines::CSS::Engine
      ]
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
      ['.', '..', '.git', 'log', 'logs', 'tmp', 'temp', 'test', 'tests', 'bin']
    end


    # generate regex for commonly excluded file types
    # for ex: dot files, .md files
    def ext_excluded_regex
      Regexp.union(/^\..*$/i, /^.*(.md)$/i, /^.*(.zip)$/i, /^.*(.rar)$/i)
    end

  end

end