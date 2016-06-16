require_relative '../spec_helper'

describe 'owi-oracle-server::users' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'creates a user named `oracle`' do
    expect(chef_run).to create_user('oracle')
  end

  it 'creates a group named `oinstall`' do
    expect(chef_run).to create_group('oinstall').with(members: ['oracle'])
  end
end
