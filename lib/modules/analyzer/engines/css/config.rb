# Analyzer -> Engines -> CSS -> config.rb
#
# Configuration for css engine

module Analyzer
  module Engines
    module CSS

      class Config

        DEFAULT_POINT = 50000.freeze

        ALL_RULES = {
          "adjoining-classes" => "compatibility",
          "box-model" => "bug Risk",
          "box-sizing" => "compatibility",
          "bulletproof-font-face" => "compatibility",
          "compatible-vendor-prefixes" => "compatibility",
          "display-property-grouping" => "bug Risk",
          "duplicate-background-images" => "bug Risk",
          "duplicate-properties" => "bug Risk",
          "empty-rules" => "bug Risk",
          "fallback-colors" => "compatibility",
          "font-faces" => "bug Risk",
          "gradients" => "compatibility",
          "import" => "bug Risk",
          "known-properties" => "bug Risk",
          "overqualified-elements" => "bug Risk",
          "regex-selectors" => "bug Risk",
          "shorthand" => "bug Risk",
          "star-property-hack" => "compatibility",
          "text-indent" => "compatibility",
          "underscore-property-hack" => "compatibility",
          "unique-headings" => "Duplication",
          "universal-selector" => "bug Risk",
          "unqualified-attributes" => "bug Risk",
          "vendor-prefix" => "compatibility",
          "zero-units" => "bug Risk"
        }.freeze

      end

    end
  end
end