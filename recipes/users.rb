#
# Cookbook Name:: owi-oracle-server
# Recipe:: users
#
# Description:: Creates the required service user(s) and group(s)
#

user 'oracle' do
  system true
  manage_home true
end

group 'oinstall' do
  members 'oracle'
  append true
end
