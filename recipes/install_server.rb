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

template "#{oracle_user_home}/init.ora" do
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

# Set the proper ulimit for the machine
execute "set ulimit for max files" do
  command "ulimit -n 65536"
  user "root"
  group "root"
  not_if "ulimit -n | grep -q 65536"
end

cookbook_file "/etc/security/limits.d/91-file-limits.conf" do
  source "91-file-limits.conf"
  user "root"
  group "root"
  mode "0644"
end

remote_install_file_source = node['owi-oracle-server']['config']['install_location']
local_install_file_source = "#{Chef::Config['file_cache_path']}/install.zip"
remote_file local_install_file_source do
  source remote_install_file_source
  owner oracle_user
  group oracle_group
  notifies :run, "execute[unzip_install_file]", :immediately
end

execute 'unzip_install_file' do
  user oracle_user
  group oracle_group
  command "unzip #{local_install_file_source} -d #{oracle_user_home}"
  action :nothing
end

execute 'run_installer' do
  user oracle_user
  group oracle_group
  cwd "/home/oracle/database"
  command "./runInstaller -silent -responseFile #{oracle_user_home}/local_response.rsp"
  action :nothing
end
