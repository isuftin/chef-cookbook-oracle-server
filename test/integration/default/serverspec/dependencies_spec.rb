require 'spec_helper.rb'

%w{ compat-libcap1 compat-libstdc++-33 libstdc++-devel gcc-c++ libaio-devel unzip }.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end
