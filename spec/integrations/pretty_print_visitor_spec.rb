require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XenConfigFile::PrettyPrintVisitor, ".visit" do
  it "returns a string representation of a parsed AST" do
    string = File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen')
    ast = XenConfigFile::Parser.new.simple_parse(string)
    XenConfigFile::PrettyPrintVisitor.visit(ast).should == <<-EOS
#  -*- mode: python; -*-
kernel = '/boot/vmlinuz-2.6.18-xenU'
memory = 712
maxmem = 4096
name = "ey00-s00348"
vif = [ 'bridge=xenbr0' ]
disk = [
         'phy:/dev/ey00-data4/root-s00348,sda1,w',
         'phy:/dev/ey00-data4/swap-s00348,sda2,w',
         'phy:/dev/ey00-data4/gfs-00218,sdb1,w!',
       ]
root = '/dev/sda1 ro'
vcpus = 1
cpu_cap = 100
    EOS
  end
end
