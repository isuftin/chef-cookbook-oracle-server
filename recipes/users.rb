#
# Cookbook Name:: owi-oracle-server
# Recipe:: users
#
# Description:: Creates the required service user(s) and group(s)
#

oracle_user = node['owi-oracle-server']['config']['oracle_user']
oracle_group = node['owi-oracle-server']['config']['oracle_group']

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
