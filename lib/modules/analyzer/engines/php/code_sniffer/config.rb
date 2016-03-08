# Analyzer -> Engines -> PHP -> CodeSniffer -> config.rb
#
# Configuration for PHP's CodeSniffer engine

module Analyzer
  module Engines
    module PHP
      module CodeSniffer

        class Config

          DEFAULT_POINT = 70000

          INVALID_SNIFFS = [
            "Internal.NoCodeFound",
            "Internal.Tokenizer.Exception"
          ].freeze

          RESULT_CONFIG = '--report=checkstyle --standard=PSR1,PSR2'

          SNIFFS = {
            "Generic.ControlStructures.InlineControlStructure.NotAllowed" => 60000,
            "Generic.Files.LineEndings.InvalidEOLChar" => 60000,
            "Generic.Files.LineLength.TooLong" => 60000,
            "Generic.Functions.FunctionCallArgumentSpacing.NoSpaceAfterComma" => 50000,
            "Generic.WhiteSpace.DisallowTabIndent.TabsUsed" => 60000,
            "Generic.WhiteSpace.ScopeIndent.Incorrect" => 50000,
            "Generic.WhiteSpace.ScopeIndent.IncorrectExact" => 50000,
            "PEAR.Functions.ValidDefaultValue.NotAtEnd" => 60000,
            "PSR1.Classes.ClassDeclaration.MissingNamespace" => 600000,
            "PSR1.Classes.ClassDeclaration.MultipleClasses" => 400000,
            "PSR1.Files.SideEffects.FoundWithSymbols" => 500000,
            "PSR2.ControlStructures.ControlStructureSpacing.SpacingAfterOpenBrace" => 50000,
            "PSR2.ControlStructures.ElseIfDeclaration.NotAllowed" => 50000,
            "PSR2.ControlStructures.SwitchDeclaration.TerminatingComment" => 50000,
            "PSR2.Files.ClosingTag.NotAllowed" => 50000,
            "PSR2.Files.EndFileNewline.NoneFound" => 50000,
            "PSR2.Methods.FunctionCallSignature.CloseBracketLine" => 50000,
            "PSR2.Methods.FunctionCallSignature.ContentAfterOpenBracket" => 50000,
            "PSR2.Methods.FunctionCallSignature.Indent" => 50000,
            "PSR2.Methods.FunctionCallSignature.MultipleArguments" => 70000,
            "PSR2.Methods.FunctionCallSignature.SpaceAfterOpenBracket" => 50000,
            "PSR2.Methods.FunctionCallSignature.SpaceBeforeCloseBracket" => 50000,
            "PSR2.Methods.FunctionCallSignature.SpaceBeforeOpenBracket" => 50000,
            "Squiz.Classes.ValidClassName.NotCamelCaps" => 50000,
            "Squiz.ControlStructures.ControlSignature.NewlineAfterOpenBrace" => 50000,
            "Squiz.ControlStructures.ControlSignature.SpaceAfterCloseBrace" => 50000,
            "Squiz.ControlStructures.ControlSignature.SpaceAfterCloseParenthesis" => 50000,
            "Squiz.ControlStructures.ControlSignature.SpaceAfterKeyword" => 50000,
            "Squiz.ControlStructures.ControlSignature.SpaceBeforeSemicolon" => 50000,
            "Squiz.ControlStructures.ForLoopDeclaration.NoSpaceAfterFirst" => 50000,
            "Squiz.ControlStructures.ForLoopDeclaration.NoSpaceAfterSecond" => 50000,
            "Squiz.Functions.FunctionDeclarationArgumentSpacing.NoSpaceBeforeArg" => 50000,
            "Squiz.Functions.MultiLineFunctionDeclaration.BraceOnSameLine" => 50000,
            "Squiz.Functions.MultiLineFunctionDeclaration.ContentAfterBrace" => 50000,
            "Squiz.WhiteSpace.ScopeClosingBrace.ContentBefore" => 50000,
            "Squiz.WhiteSpace.ScopeClosingBrace.Indent" => 50000,
            "Squiz.WhiteSpace.SuperfluousWhitespace.EndLine" => 50000,
          }.freeze

        end

      end
    end
  end
end