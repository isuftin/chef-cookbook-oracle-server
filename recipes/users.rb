#
# Cookbook Name:: owi-oracle-server
# Recipe:: users
#
# Description:: Creates the required service user(s) and group(s)
#
oracle_user_home = '/home/oracle'
oracle_user = node['owi-oracle-server']['config']['oracle_user']
oracle_group = node['owi-oracle-server']['config']['oracle_group']
oracle_home = node['owi-oracle-server']['config']['oracle_home']
oracle_base = node['owi-oracle-server']['config']['oracle_base']
oracle_sid = node['owi-oracle-server']['config']['oracle_sid']
databag_name = node['owi-oracle-server']['config']['data_bag']['name']
credentials_item_name = node['owi-oracle-server']['config']['data_bag']['item']['credentials']
credentials_item = data_bag_item(databag_name, credentials_item_name)
system_password = credentials_item['system_pass']

group oracle_group do
  append true
end

user oracle_user do
  system true
  group oracle_group
  manage_home true
end

group 'dba' do
  members oracle_user
  append true
end

directory '/home/oracle' do
  owner oracle_user
  group oracle_group
end


template "#{oracle_user_home}/.bash_profile" do
  source "oracle_bash_profile.erb"
  user oracle_user
  group oracle_group
  sensitive true
  variables ({
               :oracle_user_home => oracle_user_home,
               :oracle_user => oracle_user,
               :oracle_home => oracle_home,
               :oracle_base => oracle_base,
               :oracle_sid => oracle_sid,
               :system_password => system_password
  })
  mode "0744"
end
