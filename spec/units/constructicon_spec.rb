require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XenConfigFile::AST::ConfigFile, "when built manually" do
  before(:all) do
    @config = XenConfigFile::AST::ConfigFile.new(:declarations => [])
    @config["kernel"] = '/boot/vmlinuz-2.6.18-xenU'
    @config["memory"] = 2048
    @config["maxmem"] = 8192
    @config["vcpus"]  = 2
    @config["cpu_cap"] = 200
    @config["cpu_weight"] = 256
    @config["name"] = 'ey02-s00250'
    @config["vif"] = [
      'script=vif-eyroute,ip=10.2.64.251 10.2.192.251',
      'script=vif-bridge,bridge=clusterbr0'
    ]
    @config["disk"] = [
            'phy:/dev/ey02-dedicated02/root-s00250,sda1,w',
            'phy:/dev/ey02-dedicated02/swap-s00250,sda2,w',
            'phy:/dev/ey02-dedicated02/indexes-s00250,sda3,w',
            'phy:/dev/ey02-dedicated02/gfs-00155,sdb1,w!'
    ]
    @config["root"] = "/dev/sda1"
    @config["extra"] = "ro"
  end

  it "produces an AST with declarations" do
    @config.declarations.should_not be_empty
  end

  it "produces a usable config file when visited by the Pretty Printer" do
    XenConfigFile::PrettyPrintVisitor.visit(@config).should == <<-EOS
kernel = '/boot/vmlinuz-2.6.18-xenU'
memory = 2048
maxmem = 8192
vcpus = 2
cpu_cap = 200
cpu_weight = 256
name = 'ey02-s00250'
vif = [
        'script=vif-eyroute,ip=10.2.64.251 10.2.192.251',
        'script=vif-bridge,bridge=clusterbr0',
      ]
disk = [
         'phy:/dev/ey02-dedicated02/root-s00250,sda1,w',
         'phy:/dev/ey02-dedicated02/swap-s00250,sda2,w',
         'phy:/dev/ey02-dedicated02/indexes-s00250,sda3,w',
         'phy:/dev/ey02-dedicated02/gfs-00155,sdb1,w!',
       ]
root = '/dev/sda1'
extra = 'ro'
    EOS
  end
end
