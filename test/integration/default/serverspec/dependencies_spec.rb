require 'spec_helper.rb'

describe package('compat-libcap1') do
  it { should be_installed }
end

describe package('compat-libstdc++-33') do
  it { should be_installed }
end

describe package('libstdc++-devel') do
  it { should be_installed }
end

describe package('gcc-c++') do
  it { should be_installed }
end

describe package('libaio-devel') do
  it { should be_installed }
end

describe package('unzip') do
  it { should be_installed }
end
