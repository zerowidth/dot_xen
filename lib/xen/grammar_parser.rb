module XenConfigFile
  class GrammarParser < Treetop::Runtime::CompiledParser
    def simple_parse(io)
      parsed = parse(io)
      parsed.build unless parsed.nil?
    end
  end
end
