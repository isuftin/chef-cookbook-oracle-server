require_relative '../spec_helper'

describe 'owi-oracle-server::install_server' do
  # let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }


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
                                        'oracle_home'=> '/home/oracle',
                                        'oracle_base'=> '/home/oracle/app/oracle/product/12.1.0/dbhome_1',
                                        'db_domain'=> 'cr.usgs.gov',
                                        'memory_target'=> '2G'
                                      }
                                    }
      } })
      server.converge(described_recipe)
    end
  }

  it 'writes the configuration file' do
    expect(chef_run).to create_template('/home/oracle/local_response.rsp').with(
      user:   'oracle',
      group:  'oinstall'
    )
  end

  it 'writes the init file' do
    expect(chef_run).to create_template('/home/oracle/init.ora').with(
      user:   'oracle',
      group:  'oinstall'
    )
  end

end
