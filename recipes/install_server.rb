#
# Cookbook Name:: owi-oracle-server
# Recipe:: install_server
#
# Description:: Install the Oracle server
#

databag_name = node['owi-oracle-server']['config']['data_bag']['name']
credentials_item_name = node['owi-oracle-server']['config']['data_bag']['item']['credentials']
credentials_item = data_bag_item(databag_name, credentials_item_name)
system_password = credentials_item['system_pass']
oracle_user_home = '/home/oracle'
oracle_sid = node['owi-oracle-server']['config']['oracle_sid']
oracle_user = node['owi-oracle-server']['config']['oracle_user']
oracle_group = node['owi-oracle-server']['config']['oracle_group']
oracle_home = node['owi-oracle-server']['config']['oracle_home']
oracle_base = node['owi-oracle-server']['config']['oracle_base']
db_domain = node['owi-oracle-server']['config']['db_domain']
memory_target = node['owi-oracle-server']['config']['memory_target']


directory oracle_base do
  owner oracle_user
  group oracle_group
  mode '0775'
  recursive true
end

directory oracle_home do
  owner oracle_user
  group oracle_group
  mode '0775'
  recursive true
end

template "#{oracle_user_home}/local_response.rsp" do
  source 'local_response.rsp.erb'
  variables ({
               :hostname => node['hostname'],
               :oracle_base => oracle_base,
               :oracle_home => oracle_home,
               :group_name => oracle_group
  })
  owner oracle_user
  group oracle_group
end

# Set the proper ulimit for the machine
execute "set ulimit for max files" do
  command 'sh -c "ulimit -Hn 65536"'
  user "root"
  group "root"
  not_if 'sh -c "ulimit -Hn | grep -q 65536"'
end

cookbook_file "/etc/security/limits.d/91-file-limits.conf" do
  source "91-file-limits.conf"
  user "root"
  group "root"
  mode "0644"
end

template "write_sql_script" do
  path "#{oracle_user_home}/sql_script.sql"
  source 'sql_script.sql.erb'
  variables ({
               :oracle_sid => oracle_sid,
               :system_password => system_password,
               :oracle_base => oracle_base,
               :oracle_home => oracle_home
  })
  owner oracle_user
  group oracle_group
  sensitive true
end

remote_install_file_source = node['owi-oracle-server']['config']['install_location']
local_install_file_source = "#{Chef::Config['file_cache_path']}/install.zip"
remote_file local_install_file_source do
  source remote_install_file_source
  owner oracle_user
  group oracle_group
  notifies :run, "execute[unzip_install_file]", :immediately
  notifies :run, "bash[run_installer]", :immediately
end

execute 'unzip_install_file' do
  user oracle_user
  group oracle_group
  command "unzip -o #{local_install_file_source} -d #{oracle_user_home}"
  action :nothing
end

directory "create_archive_dir" do
  path "#{oracle_base}/oradata/#{oracle_sid}"
  owner oracle_user
  group oracle_group
  recursive true
end

%w{ archive adump fast_recovery_area }.each do |d|
  directory "#{oracle_base}/oradata/#{oracle_sid}/#{d}" do
    owner oracle_user
    group oracle_group
    recursive true
  end
end

bash 'run_installer' do
  cwd "#{oracle_user_home}/database"
  environment ({
                 'HOME' => oracle_user_home,
                 'USER' => oracle_user,
                 "PATH" => "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:#{oracle_home}/bin",
                 "ORACLE_HOME" => oracle_home,
                 "ORACLE_SID" => oracle_sid
  })
  code "sudo -u oracle -g oinstall #{oracle_user_home}/database/runInstaller -waitforcompletion -silent -responseFile #{oracle_user_home}/local_response.rsp"
  # https://community.oracle.com/message/10245974#10245974
  returns [0,1,2,3,6]
  notifies :run, "bash[post_install]", :immediately
  notifies :run, "bash[post_install_as_root]", :immediately
  notifies :run, "bash[run_sql]", :delayed
  action :nothing
end

bash 'post_install' do
  code <<-EOF
  source #{oracle_user_home}/.bash_profile && \
  cp #{oracle_home}/javavm/jdk/jdk6/lib/libjavavm12.a #{oracle_home}/lib/ && \
  cd #{oracle_home}/rdbms/lib && \
  make -f ins_rdbms.mk install && \
    mv config.o config.o.bad && \
    cd #{oracle_home}/network/lib && \
    make -f ins_net_server.mk install && \
    make -f ins_net_client.mk install && \
    cd #{oracle_home}/javavm/admin && \
    ln -s ../jdk/jdk6/admin/classes.bin . && \
    cd #{oracle_home}/bin && \
    relink as_installed && \
    relink all
  EOF
  user oracle_user
  group oracle_group
  action :nothing
end

bash 'post_install_as_root' do
  code <<-EOF
  #{oracle_base}/oraInventory/orainstRoot.sh && \
  #{oracle_home}/root.sh
  EOF
  action :nothing
end

template "write_ora_file" do
  path "#{oracle_home}/dbs/init#{oracle_sid}.ora"
  source 'init.ora.erb'
  variables ({
               :oracle_sid => oracle_sid,
               :oracle_base => oracle_base,
               :db_domain => db_domain,
               :memory_target => memory_target
  })
  owner oracle_user
  group oracle_group
end

bash "run_sql" do
  code "source #{oracle_user_home}/.bash_profile && #{oracle_home}/bin/sqlplus '/ as sysdba' @#{oracle_user_home}/sql_script.sql > #{oracle_user_home}/create_#{oracle_sid}.out"
  environment({
                "PATH" => "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:#{oracle_home}/bin",
                "ORACLE_HOME" => oracle_home,
                "ORACLE_SID" => oracle_sid
  })
  user oracle_user
  group oracle_group
  action :nothing
end
