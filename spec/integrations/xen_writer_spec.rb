require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe XenConfigFile::GrammarParser do
  describe "when re-parsing the pretty-print output and produce the same AST" do
    before(:all) do
      string = File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen')
      @parsed = XenConfigFile::GrammarParser.new.simple_parse(string)
      output = XenConfigFile::PrettyPrintVisitor.visit(@parsed)
      @reparsed = XenConfigFile::GrammarParser.new.simple_parse(output)
    end

    it "has a reparsed AST" do
      @reparsed.should be_an_instance_of(XenConfigFile::AST::ConfigFile)
    end

    it "has the same number of declarations" do
      @reparsed.declarations.size.should == @reparsed.declarations.size
    end

    def self.has_the_same(name)
      it "has the same #{name} value" do
        @reparsed[name].should_not be_nil
        @reparsed[name].value.value.should == @parsed[name].value.value
      end
    end

    has_the_same "kernel"
    has_the_same "memory"
    has_the_same "maxmem"
    has_the_same "vcpus"
    has_the_same "cpu_cap"
    has_the_same "name"
    has_the_same "root"

    it "has the same list of disks" do
      @reparsed["disk"].disks.should_not be_empty
      @parsed["disk"].disks.each_with_index do |disk, index|
        other = @reparsed["disk"].disks[index]
        disk.volume.should == other.volume
        disk.device.should == other.device
        disk.mode.should == other.mode
      end
    end

  end
end
