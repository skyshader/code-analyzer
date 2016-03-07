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

          CATEGORIES = {
            # clean code rules
            "BooleanArgumentFlag" => ["Clarity", 300000],
            "ElseExpression" => ["Clarity", 200000],
            "StaticAccess" => ["Clarity", 200000],

            # code size rules
            "CyclomaticComplexity" => ["Complexity", 100000],
            "NpathComplexity" => ["Complexity", 200000],
            "ExcessiveMethodLength" => ["Complexity", 200000],
            "ExcessiveClassLength" => ["Complexity", 200000],
            "ExcessiveParameterList" => ["Complexity", 200000],
            "ExcessivePublicCount" => ["Complexity", 700000],
            "TooManyFields" => ["Complexity", 900000],
            "TooManyMethods" => ["Complexity", 2000000],
            "ExcessiveClassComplexity" => ["Complexity", 200000],

            # controversial rules
            "Superglobals" => ["Security", 100000],
            "CamelCaseClassName" => ["Style", 500000],
            "CamelCasePropertyName" => ["Style", 500000],
            "CamelCaseMethodName" => ["Style", 1000],
            "CamelCaseParameterName" => ["Style", 500000],
            "CamelCaseVariableName" => ["Style", 25000],

            # design rules
            "ExitExpression" => ["Bug Risk", 200000],
            "EvalExpression" => ["Security", 300000],
            "GotoStatement" => ["Clarity", 200000],
            "NumberOfChildren" => ["Clarity", 1000000],
            "DepthOfInheritance" => ["Clarity", 500000],
            "CouplingBetweenObjects" => ["Clarity", 400000],
            
            # naming rules
            "ShortVariable" => ["Style", 500000],
            "LongMethod" => ["Complexity", 200000],
            "ShortMethodName" => ["Style", 800000],
            "ConstructorWithNameAsEnclosingClass" => ["Compatibility", 400000],
            "ConstantNamingConventions" => ["Style", 100000],
            "BooleanGetMethodName" => ["Style", 200000],
            
            # unused code rules
            "UnusedPrivateField" => ["Bug Risk", 200000],
            "UnusedLocalVariable" => ["Bug Risk", 200000],
            "UnusedPrivateMethod" => ["Bug Risk", 200000],
            "UnusedFormalParameter" => ["Bug Risk", 200000],
          }.freeze

        end

      end
    end
  end
end