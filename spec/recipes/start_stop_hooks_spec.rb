require_relative '../spec_helper'

describe 'owi-oracle-server::start_stop_hooks' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  oracle_home = '/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1'

  it 'creates listener.ora file' do
    expect(chef_run).to create_template("#{oracle_home}/network/admin/listener.ora")
  end

  it 'creates oracle service file' do
    expect(chef_run).to create_template("/etc/init.d/oracle")
  end

  it 'creates oratab file' do
    expect(chef_run).to create_template("/etc/oratab")
  end

  it 'Skips execute for chkconfig' do
    expect(chef_run).to_not run_execute('chkconfig --add oracle')
  end

end
