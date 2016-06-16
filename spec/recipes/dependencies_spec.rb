require_relative '../spec_helper'

describe 'owi-oracle-server::dependencies' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'installs the compat-libcap1 package' do
    expect(chef_run).to install_package('compat-libcap1')
  end

  it 'installs the compat-libstdc++-33 package' do
    expect(chef_run).to install_package('compat-libstdc++-33')
  end

  it 'installs the libstdc++-devel package' do
    expect(chef_run).to install_package('libstdc++-devel')
  end

  it 'installs the gcc-c++ package' do
    expect(chef_run).to install_package('gcc-c++')
  end

  it 'installs the libaio-devel package' do
    expect(chef_run).to install_package('libaio-devel')
  end
end
