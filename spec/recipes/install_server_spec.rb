require_relative '../spec_helper'

oracle_home = '/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1'
oracle_base = '/u01/oradata/auto'
oracle_user_home = '/home/oracle'
oracle_sid = 'admin'

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
                                        'oracle_sid'=> oracle_sid,
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

  before do
    stub_command('sh -c "ulimit -Hn | grep -q 65536"').and_return(false)
  end

  it 'creates a home directory' do
    expect(chef_run).to create_directory(oracle_home)
  end

  it 'creates a base directory' do
    expect(chef_run).to create_directory(oracle_base)
  end

  it 'creates a base sid directory' do
    expect(chef_run).to create_directory("#{oracle_base}/oradata/#{oracle_sid}")
  end
  it 'creates a base sid directory' do
    expect(chef_run).to create_directory("#{oracle_base}/oradata/#{oracle_sid}/archive")
  end
  it 'creates a base sid directory' do
    expect(chef_run).to create_directory("#{oracle_base}/oradata/#{oracle_sid}/adump")
  end
  it 'creates a base sid directory' do
    expect(chef_run).to create_directory("#{oracle_base}/oradata/#{oracle_sid}/fast_recovery_area")
  end

  it 'runs ulimit' do
    expect(chef_run).to run_execute('sh -c "ulimit -Hn 65536"').with(
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
    expect(chef_run).to create_template("#{oracle_user_home}/local_response.rsp").with(
      user:   'oracle',
      group:  'oinstall'
    )
  end

  it 'writes the init file' do
    expect(chef_run).to create_template("#{oracle_home}/dbs/initadmin.ora").with(
      user:   'oracle',
      group:  'oinstall'
    )
  end


  it 'writes the sql script' do
    expect(chef_run).to create_template("#{oracle_user_home}/sql_script.sql").with(
      user:   'oracle',
      group:  'oinstall'
    )
  end

  it 'unzips the installation file' do
    resource = chef_run.execute('unzip_install_file')
    expect(resource).to do_nothing
  end

  it 'runs the installation file' do
    expect(chef_run).to_not run_bash('run_installer')
  end

  it 'skip runs the post_install script' do
    expect(chef_run).to_not run_bash('post_install')
  end

  it 'skip runs the post_install_as_root script' do
    expect(chef_run).to_not run_bash('post_install_as_root')
  end

  it 'skip runs the run_sql script' do
    expect(chef_run).to_not run_bash('run_sql')
  end

  it 'moves the installation file' do
    expect(chef_run).to  create_remote_file(File.join(Chef::Config[:file_cache_path], 'install.zip')).with(owner: 'oracle')
  end

end
