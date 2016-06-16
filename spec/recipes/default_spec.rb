require_relative '../spec_helper'

describe 'owi-oracle-server::default' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'includes the dependencies recipe' do
    expect(chef_run).to include_recipe('owi-oracle-server::dependencies')
    expect(chef_run).to include_recipe('owi-oracle-server::users')
  end

end
