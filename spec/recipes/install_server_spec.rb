require_relative '../spec_helper'

describe 'owi-oracle-server::install_server' do

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
                                        'oracle_home'=> '/u01/oradata/auto',
                                        'oracle_base'=> '/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1',
                                        'db_domain'=> 'cr.usgs.gov',
                                        'memory_target'=> '2G',
                                        'install_location' => 'file:///tmp/kitchen/data/install.zip'
                                      }
                                    }
      } })
      server.converge(described_recipe)
    end
  }

  before do
    # allow_any_instance_of(chef_run).to receive(:should_skip).and_return(false)
    stub_command("ulimit -n | grep -q 65536").and_return(false)
    # Chef::Resource::Execute.any_instance.stub(:should_skip?).and_return(false)
  end

  it 'creates a home directory' do
    expect(chef_run).to create_directory('/u01/oradata/auto')
  end

  it 'runs ulimit' do
    expect(chef_run).to run_execute('ulimit -n 65536').with(
      user:   'root',
      group:  'root'
    )
  end

  it 'writes the limits file' do
    expect(chef_run).to create_cookbook_file('/etc/security/limits.d/91-file-limits.conf').with(
      user:   'root',
      group:  'root'
    )
  end

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

  it 'unzips the installation file' do
    resource = chef_run.execute('unzip_install_file')
    expect(resource).to do_nothing
  end

  it 'unzips the installation file' do
    resource = chef_run.execute('run_installer')
    expect(resource).to do_nothing
  end

  it 'moves the installation file' do
    expect(chef_run).to  create_remote_file(File.join(Chef::Config[:file_cache_path], 'install.zip')).with(owner: 'oracle')
  end

end
