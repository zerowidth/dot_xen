require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def parsed_ast
  string = File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen')
  XenConfigFile::Parser.new.simple_parse(string)
end


describe XenConfigFile::AST do
  include XenConfigFile::AST

  before(:all) do
    @ast = XenConfigFile::Parser.new.simple_parse(File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen'))
  end

  describe XenConfigFile::AST::ConfigFile do
    it "has declarations" do
      @ast.should have_at_least(8).declarations
    end
  end

end

describe XenConfigFile::AST::ConfigFile do

  before(:each) do
    @config_file = parsed_ast
  end

  it "has a variable for each meaningful line of the file" do
    @config_file.should have(10).declarations
  end

  it "has a comment nodes" do
    @config_file.declarations.first.should be_an_instance_of(XenConfigFile::AST::Comment)
  end

  it "has assignment nodes" do
    @config_file.declarations[1].should be_an_instance_of(XenConfigFile::AST::Assignment)
  end

  it "has array assignment nodes" do
    @config_file.declarations[5].should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
  end

  it "has a disk array assignment" do
    @config_file.declarations[6].should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
  end

  it "has comments" do
    @config_file.should have(1).comments
    @config_file.comments.first.should be_an_instance_of(XenConfigFile::AST::Comment)
  end

  describe "#[]" do

    it "retrieves the assignment with a name matching the given string" do
      @config_file["disk"].should == @config_file.declarations[6]
    end

    it "returns nil if the named value isn't found" do
      @config_file["what"].should be_nil
    end

  end

  describe "#[]=" do
    describe "when assigning to a name that already exists" do

      it "replaces the existing value of the assignment with a single quoted string when assigning a string" do
        @config_file["name"] = "lol"
        @config_file["name"].value.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString)
        @config_file["name"].value.value.should == "lol"
      end

      it "replaces the existing value of the assignment node with a number when assigning a number" do
        @config_file["memory"] = 123
        @config_file["memory"].value.should be_an_instance_of(XenConfigFile::AST::Number)
        @config_file["memory"].value.value.should == 123
      end

      it "replaces the value of the assignment with a new array"

      it "replaces the value of the assignment with new disk nodes if the name is disk"

    end

    describe "when assigning to a name that doesn't exist" do

      it "creates a new assignment node with a single quoted string when assigning a string" do
        lambda do
          @config_file["thing"] = "stuff"
        end.should change(@config_file.declarations, :size).by(1)
        new_node = @config_file.declarations.last
        new_node.should be_an_instance_of(XenConfigFile::AST::Assignment)
        new_node.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
        new_node.value.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString)
        new_node.value.value.should == "stuff"
      end

      it "creates a new assignment node with a number when assigning a number" do
        lambda do
          @config_file["thing"] = 12345
        end.should change(@config_file.declarations, :size).by(1)
        new_node = @config_file.declarations.last
        new_node.should be_an_instance_of(XenConfigFile::AST::Assignment)
        new_node.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
        new_node.value.should be_an_instance_of(XenConfigFile::AST::Number)
        new_node.value.value.should == 12345
      end

    end

  end
  # before(:all) do
  #   @config = XenConfigFile::AST::ConfigFile.new({:declarations => []})
  # end

  # describe "[]=" do
  #   before(:all) do
  #     @config[:cpu_cap] = 200
  #   end
  #   it "should let me fetch the declarations i set" do
  #     @config[:cpu_cap].should == 200
  #   end
  # end
end

describe XenConfigFile::AST::Comment do
  it "has a value" do
    comment = parsed_ast.declarations.first
    comment.should be_an_instance_of(XenConfigFile::AST::Comment)
    comment.value.should == "  -*- mode: python; -*-"
  end
end

describe XenConfigFile::AST::Assignment do
  before(:all) do
    @assignment = parsed_ast.declarations[1]
    @assignment.should be_an_instance_of(XenConfigFile::AST::Assignment)
  end

  it "has a name" do
    @assignment.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
    @assignment.name.value.should == "kernel"
  end

  it "has a value string" do
    @assignment.value.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString)
  end

end

describe XenConfigFile::AST::ArrayAssignment do
  before(:all) do
    @assignment = parsed_ast.declarations[5]
    @assignment.should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
  end

  it "has a name" do
    @assignment.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
    @assignment.name.value.should == "vif"
  end

  it "has an array of literals as a value" do
    @assignment.should have(1).value
    @assignment.values.each { |item| item.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString) }
  end

end

describe XenConfigFile::AST::DiskArrayAssignment do
  before(:all) do
    @assignment = parsed_ast.declarations[6]
    @assignment.should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
  end

  it "has a name" do
    @assignment.name.should be_an_instance_of(XenConfigFile::AST::StringLiteral)
    @assignment.name.value.should == "disk"
  end

  it "has an array of disks" do
    @assignment.should have(3).disks
    @assignment.disks.each { |disk| disk.should be_an_instance_of(XenConfigFile::AST::Disk)}
  end
end

describe XenConfigFile::AST::SingleQuotedString do
  before(:all) do
    @string = parsed_ast.declarations[1].value
    @string.should be_an_instance_of(XenConfigFile::AST::SingleQuotedString)
  end
  it "has a value" do
    @string.value.should == "/boot/vmlinuz-2.6.18-xenU"
  end
end

describe XenConfigFile::AST::DoubleQuotedString do
  before(:all) do
    @string = parsed_ast.declarations[4].value
    @string.should be_an_instance_of(XenConfigFile::AST::DoubleQuotedString)
  end
  it "has a value" do
    @string.value.should == "ey00-s00348"
  end
end

describe XenConfigFile::AST::Number do
  before(:all) do
    @number = parsed_ast.declarations[2].value
    @number.should be_an_instance_of(XenConfigFile::AST::Number)
  end
  it "has a value" do
    @number.value.should == 712
  end
end


describe XenConfigFile::AST::Disk do
  before(:all) do
    @disk = parsed_ast.declarations[6].disks[0]
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
#       @disks = XenConfigFile::AST::Disk.build({:declarations => [XenConfigFile::AST::ArrayAssignment.new(:disk, @params)]})
#     end
#     it "should build successfully" do
#       @disks.should_not be_nil
#     end
#     it "should have three elements" do
#       @disks.should have(3).entries
#     end
#   end
end