require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def parsed_ast
  string = File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen')
  XenConfigFile::GrammarParser.new.simple_parse(string)
end


describe XenConfigFile::AST do
  include XenConfigFile::AST

  before(:all) do
    @ast = XenConfigFile::GrammarParser.new.simple_parse(File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen'))
  end

  describe XenConfigFile::AST::ConfigFile do
    it "has declarations" do
      @ast.should have_at_least(8).declarations
    end
  end

end

describe XenConfigFile::AST::ConfigFile do

  before(:each) do
    @config = parsed_ast
  end

  it "has a variable for each meaningful line of the file" do
    @config.should have(10).declarations
  end

  it "has a comment nodes" do
    @config.declarations.first.should be_an_instance_of(XenConfigFile::AST::Comment)
  end

  it "has assignment nodes" do
    @config.declarations[1].should be_an_instance_of(XenConfigFile::AST::Assignment)
  end

  it "has array assignment nodes" do
    @config.declarations[5].should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
  end

  it "has a disk array assignment" do
    @config.declarations[6].should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
  end

  it "has comments" do
    @config.should have(1).comments
    @config.comments.first.should be_an_instance_of(XenConfigFile::AST::Comment)
  end

  describe "#[]" do

    it "retrieves the assignment with a name matching the given string" do
      @config["disk"].should == @config.declarations[6]
    end

    it "returns nil if the named value isn't found" do
      @config["what"].should be_nil
    end

  end

  describe "#delete" do
    it "deletes the node from the declarations with the given name" do
      lambda { @config.delete("memory") }.should change(@config.declarations, :size).by(-1)
      @config["memory"].should be_nil
    end
  end

  describe "#[]=" do
    describe "when assigning a string" do
      it "replaces an existing node with an assignment with a single quoted string" do
        lambda { @config["name"] = "lol" }.should_not change(@config.declarations, :size)
        @config["name"].value.should == "lol"
      end
      it "appends a new node if the name doesn't exist" do
        lambda { @config["what"] = "nooo" }.should change(@config.declarations, :size).by(1)
        @config["what"].should be_an_instance_of(XenConfigFile::AST::Assignment)
        @config["what"].value.should == "nooo"
      end
    end

    describe "when assigning a number" do
      it "replaces an existing node with a new number assignment" do
        lambda { @config["memory"] = 123 }.should_not change(@config.declarations, :size)
        @config["memory"].value.should == 123
      end
      it "appends a new assignment node if the name doesn't exist" do
        lambda { @config["numba"] = 12345 }.should change(@config.declarations, :size).by(1)
        @config["numba"].should be_an_instance_of(XenConfigFile::AST::Assignment)
        @config["numba"].value.should == 12345
      end
    end

    describe "when assigning an array" do
      it "replaces an existing node with a new array assignment" do
        lambda { @config["vif"] = %w(foo bar) }.should_not change(@config.declarations, :size)
        @config["vif"].should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
        @config["vif"].values.should == %w(foo bar)
      end
      it "appends a new array assignment node for an new name" do
        lambda { @config["numbaz"] = [1, 2, 3] }.should change(@config.declarations, :size).by(1)
        @config["numbaz"].should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
        @config["numbaz"].values.should == [1, 2, 3]
      end
    end

    describe "when assigning to the disk name" do
      before(:all) do
        @disk_names = [
          'phy:/dev/ey02-dedicated02/root-s00250,sda1,w',
          'phy:/dev/ey02-dedicated02/swap-s00250,sda2,w',
          'phy:/dev/ey02-dedicated02/indexes-s00250,sda3,w',
          'phy:/dev/ey02-dedicated02/gfs-00155,sdb1,w!'
        ]
      end
      describe "when the disk already exists" do
        it "replaces the disks with new disks" do
          lambda { @config["disk"] = @disk_names }.should_not change(@config.declarations, :size)
          @config["disk"].should have(4).disks
          @config["disk"].disks.each { |disk| disk.should be_an_instance_of(XenConfigFile::AST::Disk) }
        end
      end
      describe "when the disk doesn't exist" do
        before(:each) do
          @config.delete("disk")
        end
        it "adds a new disk node" do
          lambda { @config["disk"] = @disk_names }.should change(@config.declarations, :size).by(1)
          @config["disk"].should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
        end
      end
    end

  end

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
    @assignment.name.should == "kernel"
  end

  it "has a value" do
    @assignment.value.should == '/boot/vmlinuz-2.6.18-xenU'
  end

end

describe XenConfigFile::AST::ArrayAssignment do
  before(:all) do
    @assignment = parsed_ast.declarations[5]
    @assignment.should be_an_instance_of(XenConfigFile::AST::ArrayAssignment)
  end

  it "has a name" do
    @assignment.name.should == "vif"
  end

  it "has an array of literals as a value" do
    @assignment.should have(1).value
    @assignment.values.each { |item| item.should be_an_instance_of(String) }
  end

end

describe XenConfigFile::AST::DiskArrayAssignment do
  before(:all) do
    @assignment = parsed_ast.declarations[6]
    @assignment.should be_an_instance_of(XenConfigFile::AST::DiskArrayAssignment)
  end

  it "has a name" do
    @assignment.name.should == "disk"
  end

  it "has an array of disks" do
    @assignment.should have(3).disks
    @assignment.disks.each { |disk| disk.should be_an_instance_of(XenConfigFile::AST::Disk)}
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

  describe "when initialized with a string" do
    before(:all) do
      @disk = XenConfigFile::AST::Disk.new('phy:/dev/ey00-data4/root-s00348,sda1,w')
    end

    it "sets the volume" do
      @disk.volume.should == "phy:/dev/ey00-data4/root-s00348"
    end

    it "sets the device" do
      @disk.device.should == "sda1"
    end

    it "sets the mode" do
      @disk.mode.should == "w"
    end
  end

end