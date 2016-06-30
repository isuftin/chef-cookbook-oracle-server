require_relative '../spec_helper'

oracle_home = '/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1'
oracle_base = '/u01/oradata/auto'
oracle_user_home = '/home/oracle'
oracle_user = 'oracle'
oracle_group = 'oinstall'

describe 'owi-oracle-server::default' do
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
                                        'oracle_user'=> oracle_user,
                                        'oracle_group'=> oracle_group,
                                        'oracle_sid'=> 'admin',
                                        'oracle_base'=> oracle_base,
                                        'oracle_home'=> oracle_home,
                                        'db_domain'=> '',
                                        'memory_target'=> '2G',
                                        'install_location' => 'file:///tmp/kitchen/data/install.zip'
                                      }
                                    }
      } })
      server.converge(described_recipe)
    end
  }



  before do
    stub_command('sh -c "ulimit -Hn | grep -q 65536"').and_return(false)
  end

  it 'includes the dependencies recipe' do
    expect(chef_run).to include_recipe('owi-oracle-server::dependencies')
  end

  it 'includes the users recipe' do
    expect(chef_run).to include_recipe('owi-oracle-server::users')
  end

  it 'includes the install_server recipe' do
    expect(chef_run).to include_recipe('owi-oracle-server::install_server')
  end

  it 'includes the install_server recipe' do
    expect(chef_run).to include_recipe('owi-oracle-server::start_stop_hooks')
  end

end
