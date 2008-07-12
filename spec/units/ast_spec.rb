require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def parsed_ast(string = File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen'))
  XenConfigFile::Parser.new.simple_parse(string)
end


describe XenConfigFile::AST do
  include XenConfigFile::AST

  before(:all) do
    @ast = XenConfigFile::Parser.new.simple_parse(File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen'))
  end

  describe XenConfigFile::AST::ConfigFile do
    it "has variables" do
      @ast.should have_at_least(8).variables
    end
  end

end


describe XenConfigFile::AST::ConfigFile do

  describe "when parsed from a file" do
    before(:all) do
      @config_file = parsed_ast
    end

    it "has a variable for each meaningful line of the file" do
      @config_file.should have(10).variables
    end

    it "has a comment nodes" do
      @config_file.variables.first.should be_an_instance_of(XenConfigFile::AST::Comment)
    end

    it "has assignment nodes" do
      @config_file.variables[1].should be_an_instance_of(XenConfigFile::AST::Assignment)
    end

    it "has array assignment nodes" do
      @config_file.variables[5].should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
    end

    it "has a disk array assignment" do
      @config_file.variables[6].should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
    end

  end

  # before(:all) do
  #   @config = XenConfigFile::AST::ConfigFile.new({:variables => []})
  # end

  # describe "[]=" do
  #   before(:all) do
  #     @config[:cpu_cap] = 200
  #   end
  #   it "should let me fetch the variables i set" do
  #     @config[:cpu_cap].should == 200
  #   end
  # end
end

describe XenConfigFile::AST::Comment do
  it "has a value" do
    comment = parsed_ast.variables.first
    comment.should be_an_instance_of(XenConfigFile::AST::Comment)
    comment.value.should == "  -*- mode: python; -*-"
  end
end

describe XenConfigFile::AST::Assignment do
  before(:all) do
    @assignment = parsed_ast.variables[1]
    @assignment.should be_an_instance_of(XenConfigFile::AST::Assignment)
  end

  it "has a name literal" do
    @assignment.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
  end

  it "has a value string" do
    @assignment.value.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString)
  end

  # describe "initialize" do
  #   before(:all) do
  #     @ass = XenConfigFile::AST::Assignment.new(:number, 42)
  #   end
  #   it "should know its lhs" do
  #     @ass.lhs.should == :number
  #   end
  #   it "should know its rhs" do
  #     @ass.rhs.should == 42
  #   end
  # end
end

describe XenConfigFile::AST::ArrayAssignment do
  before(:all) do
    @assignment = parsed_ast.variables[5]
    @assignment.should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
  end

  it "has a name literal" do
    @assignment.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
  end

  it "has an array of literals as a value" do
    @assignment.should have(1).value
    @assignment.value.each { |item| item.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString) }
  end

  # describe "initialize" do
  #   before(:all) do
  #     @ass = XenConfigFile::AST::ArrayAssignment.new(:number, [42, 'forty-two', 666])
  #   end
  #   it "should know its lhs" do
  #     @ass.lhs.should == :number
  #   end
  #   it "should know its rhs" do
  #     @ass.rhs.should == [42, 'forty-two', 666]
  #   end
  # end
end

describe XenConfigFile::AST::DiskArrayAssignment do
  before(:all) do
    @assignment = parsed_ast.variables[6]
    @assignment.should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
  end

  it "has an array of disks" do
    @assignment.should have(3).disks
    @assignment.disks.each { |disk| disk.should be_an_instance_of(XenConfigFile::AST::Disk)}
  end
end

describe XenConfigFile::AST::StringLiteral do
  before(:all) do
    @literal = parsed_ast.variables[5].name
    @literal.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
  end

  it "has a value" do
    @literal.value.should == "vif"
  end

  # describe "initialize" do
  #   before(:all) do
  #     @str = XenConfigFile::AST::LiteralString.new('foo')
  #   end
  # end
end

describe XenConfigFile::AST::SingleQuotedString do
  before(:all) do
    @string = parsed_ast.variables[1].value
    @string.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString)
  end
  it "has a value" do
    @string.value.should == "/boot/vmlinuz-2.6.18-xenU"
  end
end

describe XenConfigFile::AST::DoubleQuotedString do
  before(:all) do
    @string = parsed_ast.variables[4].value
    @string.should be_an_instance_of(XenConfigFile::AST::DoubleQuotedString)
  end
  it "has a value" do
    @string.value.should == "ey00-s00348"
  end
end

describe XenConfigFile::AST::Number do
  before(:all) do
    @number = parsed_ast.variables[2].value
    @number.should be_an_instance_of(XenConfigFile::AST::Number)
  end
  it "has a value" do
    @number.value.should == 712
  end
end


describe XenConfigFile::AST::Disk do
  before(:all) do
    @disk = parsed_ast.variables[6].disks[0]
    @disk.should be_an_instance_of(XenConfigFile::AST::Disk)
  end

  it "has a volume" do
    @disk.volume.should == "phy:/dev/ey00-data4/root-s00348"
  end

  it "has a device" do
    @disk.device.should == "sda1"
  end

  it "has a mode" do
    @disk.mode.should == "w"
  end

#   describe "initialize" do
#     before(:all) do
#       @disk = XenConfigFile::AST::Disk.new('phy:/dev/ey00-data4/root-s00348', 'sda1', 'w')
#     end
#     it "should create successfully" do
#       @disk.should_not be_nil
#     end
#     it "should assign the volume" do
#       @disk.volume.should == 'phy:/dev/ey00-data4/root-s00348'
#     end
#     it "should assign the device" do
#       @disk.device.should == 'sda1'
#     end
#     it "should assign the mode" do
#       @disk.mode.should == 'w'
#     end
#   end
#
#   describe "build" do
#     before(:all) do
#       @params = ["phy:/dev/ey00-data4/root-s00348,sda1,w", "phy:/dev/ey00-data4/swap-s00348,sda2,w", "phy:/dev/ey00-data4/gfs-00218,sdb1,w!"]
#       @disks = XenConfigFile::AST::Disk.build({:variables => [XenConfigFile::AST::ArrayAssignment.new(:disk, @params)]})
#     end
#     it "should build successfully" do
#       @disks.should_not be_nil
#     end
#     it "should have three elements" do
#       @disks.should have(3).entries
#     end
#   end
end