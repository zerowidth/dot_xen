require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XenConfigFile::GrammarParser, ".simple_parse" do
  before(:all) do
    @parser = XenConfigFile::GrammarParser.new
  end
  describe "with ey00-s000348.xen as input" do
     before(:all) do
       @result = @parser.simple_parse(File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen'))
     end
     it "isn't nil" do
       @result.should_not be_nil
     end

     it "returns an AST instance of the config file" do
       @result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)
     end
   end
end
