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
oracle_sid = node['owi-oracle-server']['config']['oracle_sid']
oracle_user = node['owi-oracle-server']['config']['oracle_user']
oracle_group = node['owi-oracle-server']['config']['oracle_group']
oracle_home = node['owi-oracle-server']['config']['oracle_home']
oracle_base = node['owi-oracle-server']['config']['oracle_base']
db_domain = node['owi-oracle-server']['config']['db_domain']
memory_target = node['owi-oracle-server']['config']['memory_target']

template "#{oracle_home}/local_response.rsp" do
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

template "#{oracle_home}/init.ora" do
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
