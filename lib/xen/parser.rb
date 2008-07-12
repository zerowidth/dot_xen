module XenConfigFile
  class Parser < Treetop::Runtime::CompiledParser
    include Grammar
    def simple_parse(io)
      parsed = parse(io)
      parsed.build unless parsed.nil?
    end
  end
end
