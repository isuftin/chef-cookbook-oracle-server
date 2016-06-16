#
# Cookbook Name:: owi-oracle-server
# Recipe:: users
#
# Description:: Creates the required service user(s) and group(s)
#

oracle_user = node['owi-oracle-server']['config']['oracle_user']
oracle_group = node['owi-oracle-server']['config']['oracle_group']

user oracle_user do
  system true
  manage_home true
end

group oracle_group do
  members oracle_user
  append true
end

directory node['owi-oracle-server']['config']['oracle_home'] do
  owner oracle_user
  group oracle_group
end
