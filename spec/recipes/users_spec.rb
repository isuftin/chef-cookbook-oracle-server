require_relative '../spec_helper'

oracle_home = '/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1'
oracle_base = '/u01/oradata/auto'

describe 'owi-oracle-server::users' do
  let(:chef_run) {
    ChefSpec::ServerRunner.new do |node, server|
      server.create_data_bag('owi-oracle-server-_default', {
                               'credentials' => {
                                 'system_pass' => 'password12345'
                               }
      })
      server.create_environment('default', {
                                  default_attributes: {
                                    'owi-oracle-server' => {
                                      'config'=> {
                                        'data_bag'=> {
                                          'name'=> 'owi-oracle-server-_default',
                                          'item'=> {
                                            'credentials'=> 'credentials'
                                          }
                                        },
                                        'oracle_user'=> 'oracle',
                                        'oracle_group'=> 'oinstall',
                                        'oracle_sid'=> 'admin',
                                        'oracle_base'=> oracle_base,
                                        'oracle_home'=> oracle_home,
                                        'db_domain'=> 'cr.usgs.gov',
                                        'memory_target'=> '2G',
                                        'install_location' => 'file:///tmp/kitchen/data/install.zip'
                                      }
                                    }
      } })
      server.converge(described_recipe)
    end
  }

  it 'creates a user named `oracle`' do
    expect(chef_run).to create_user('oracle')
  end

  it 'creates a group named `oinstall`' do
    expect(chef_run).to create_group('oinstall')
  end

  it 'creates a group named `dba` and adds the oracle user to it' do
    expect(chef_run).to create_group('dba')
  end

  it 'creates a directory named `/home/oracle`' do
    expect(chef_run).to create_directory('/home/oracle').with(
      user:   'oracle',
      group:  'oinstall'
    )
  end

  it 'creates a bash profile file' do
    expect(chef_run).to create_template('/home/oracle/.bash_profile')
  end
end
