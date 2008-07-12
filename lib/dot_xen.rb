require "rubygems"
require "treetop"
require "treehouse"

require File.dirname(__FILE__) + '/xen/ast'
require File.dirname(__FILE__) + '/xen/pretty_print_visitor'
Treetop.load File.dirname(__FILE__) + '/xen/dot_xen.treetop'

module XenConfigFile
  class Parser < Treetop::Runtime::CompiledParser
    include Grammar
    def simple_parse(io)
      parsed = parse(io)
      parsed.build unless parsed.nil?
    end
  end
end
