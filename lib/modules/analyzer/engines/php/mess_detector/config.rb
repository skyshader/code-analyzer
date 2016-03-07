# Analyzer -> Engines -> PHP -> MessDetector -> config.rb
#
# Configuration for PHP's MessDetector engine

module Analyzer
  module Engines
    module PHP
      module MessDetector

        class Config

          RULESETS = 'cleancode,codesize,controversial,design,naming,unusedcode'.freeze

          DEFAULT_POINT = 100000

          RESULT_FORMAT = 'xml'

          CATEGORIES = {
            # clean code rules
            "BooleanArgumentFlag" => ["clarity", 300000],
            "ElseExpression" => ["clarity", 200000],
            "StaticAccess" => ["clarity", 200000],

            # code size rules
            "CyclomaticComplexity" => ["complexity", 100000],
            "NpathComplexity" => ["complexity", 200000],
            "ExcessiveMethodLength" => ["complexity", 200000],
            "ExcessiveClassLength" => ["complexity", 200000],
            "ExcessiveParameterList" => ["complexity", 200000],
            "ExcessivePublicCount" => ["complexity", 700000],
            "TooManyFields" => ["complexity", 900000],
            "TooManyMethods" => ["complexity", 2000000],
            "ExcessiveClassComplexity" => ["complexity", 200000],

            # controversial rules
            "Superglobals" => ["security", 100000],
            "CamelCaseClassName" => ["style", 500000],
            "CamelCasePropertyName" => ["style", 500000],
            "CamelCaseMethodName" => ["style", 1000],
            "CamelCaseParameterName" => ["style", 500000],
            "CamelCaseVariableName" => ["style", 25000],

            # design rules
            "ExitExpression" => ["bug risk", 200000],
            "EvalExpression" => ["security", 300000],
            "GotoStatement" => ["clarity", 200000],
            "NumberOfChildren" => ["clarity", 1000000],
            "DepthOfInheritance" => ["clarity", 500000],
            "CouplingBetweenObjects" => ["clarity", 400000],
            
            # naming rules
            "ShortVariable" => ["style", 500000],
            "LongMethod" => ["complexity", 200000],
            "ShortMethodName" => ["style", 800000],
            "ConstructorWithNameAsEnclosingClass" => ["compatibility", 400000],
            "ConstantNamingConventions" => ["style", 100000],
            "BooleanGetMethodName" => ["style", 200000],
            
            # unused code rules
            "UnusedPrivateField" => ["bug risk", 200000],
            "UnusedLocalVariable" => ["bug risk", 200000],
            "UnusedPrivateMethod" => ["bug risk", 200000],
            "UnusedFormalParameter" => ["bug risk", 200000],
          }.freeze

        end

      end
    end
  end
end