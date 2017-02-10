default['owi-oracle-server']['config']['data_bag']['name'] = 'owi-oracle-server-_default'
default['owi-oracle-server']['config']['data_bag']['item']['credentials'] = 'credentials'

# These configuration options are specific to the installation and not the system
default['owi-oracle-server']['config']['oracle_user'] = 'oracle'
default['owi-oracle-server']['config']['oracle_group'] = 'oinstall'
default['owi-oracle-server']['config']['oracle_sid'] = 'admin'
default['owi-oracle-server']['config']['oracle_base'] = '/u01/oradata/auto'
default['owi-oracle-server']['config']['oracle_home'] = '/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1'
default['owi-oracle-server']['config']['db_domain'] = ''
default['owi-oracle-server']['config']['memory_target'] = '2G'
default['owi-oracle-server']['config']['oracle_global_dbname'] = ''

# The following is useful if installing the client through the install_client recipe
default['owi-oracle-server']['config']['install_location'] = 'file:///tmp/kitchen/data/install.zip'
default['owi-oracle-server']['config']['basic_client_install_location'] = 'file:///tmp/kitchen/data/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm'
default['owi-oracle-server']['config']['sqlplus_client_install_location'] = 'file:///tmp/kitchen/data/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm'
default['owi-oracle-server']['config']['jdbc_client_install_location'] = 'file:///tmp/kitchen/data/oracle-instantclient12.1-jdbc-12.1.0.2.0-1.x86_64.rpm'
default['owi-oracle-server']['config']['ld_library_path'] = '/usr/lib/oracle/12.1/client64/lib'
