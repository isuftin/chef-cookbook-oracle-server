require_relative '../spec_helper'

describe 'owi-oracle-server::default' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  # it 'includes the dependencies recipe' do
  #   expect(chef_run).to include_recipe('owi-oracle-server::dependencies')
  # end

  # it 'includes the users recipe' do
  #   expect(chef_run).to include_recipe('owi-oracle-server::users')
  # end

  # it 'includes the install_server recipe' do
  #   expect(chef_run).to include_recipe('owi-oracle-server::install_server')
  # end

end
