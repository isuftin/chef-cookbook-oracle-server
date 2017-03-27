require_relative '../spec_helper'

describe 'owi-oracle-server::update_useradd' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'creates a template with the default action' do
    expect(chef_run).to create_template('/etc/default/useradd').with(
      user: 'root',
      group: 'root',
      mode: 0o600
    )
  end

end
