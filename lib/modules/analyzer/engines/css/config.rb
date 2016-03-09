# Analyzer -> Engines -> CSS -> config.rb
#
# Configuration for css engine

module Analyzer
  module Engines
    module CSS

      class Config

        DEFAULT_POINT = 50000.freeze

        RESULT_CONFIG = '--format=checkstyle-xml --exclude-list=.min.css --ignore=ids,order-alphabetical,important,font-faces,import,regex-selectors,universal-selector,floats,font-sizes,outline-none,qualified-headings,unique-headings'

        ALL_RULES = {
          "net.csslint.adjoining-classes" => "compatibility",
          "net.csslint.box-model" => "bug risk",
          "net.csslint.box-sizing" => "compatibility",
          "net.csslint.bulletproof-font-face" => "compatibility",
          "net.csslint.compatible-vendor-prefixes" => "compatibility",
          "net.csslint.display-property-grouping" => "bug risk",
          "net.csslint.duplicate-background-images" => "bug risk",
          "net.csslint.duplicate-properties" => "bug risk",
          "net.csslint.empty-rules" => "bug risk",
          "net.csslint.fallback-colors" => "compatibility",
          "net.csslint.gradients" => "compatibility",
          "net.csslint.known-properties" => "bug risk",
          "net.csslint.overqualified-elements" => "bug risk",
          "net.csslint.shorthand" => "bug risk",
          "net.csslint.star-property-hack" => "compatibility",
          "net.csslint.text-indent" => "compatibility",
          "net.csslint.underscore-property-hack" => "compatibility",
          "net.csslint.unqualified-attributes" => "bug risk",
          "net.csslint.vendor-prefix" => "compatibility",
          "net.csslint.zero-units" => "bug risk"
        }.freeze

      end

    end
  end
end