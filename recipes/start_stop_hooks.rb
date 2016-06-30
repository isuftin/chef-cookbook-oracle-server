#
# Cookbook Name:: owi-oracle-server
# Recipe:: start_stop_hooks.rb
#
# Description:: Creates database start and stop hooks for system startup/shutdown
#

oracle_user = node['owi-oracle-server']['config']['oracle_user']
oracle_group = node['owi-oracle-server']['config']['oracle_group']
oracle_sid = node['owi-oracle-server']['config']['oracle_sid']
oracle_home = node['owi-oracle-server']['config']['oracle_home']
db_domain = node['owi-oracle-server']['config']['db_domain']

template "/etc/oratab" do
  source "oratab.erb"
  variables ({
               :oracle_sid => oracle_sid,
               :oracle_home => oracle_home
  })
  owner oracle_user
  group oracle_group
  mode "0664"
end

template "#{oracle_home}/network/admin/listener.ora" do
  source "listener.ora.erb"
  variables ({
               :oracle_sid => oracle_sid,
               :oracle_home => oracle_home,
               :address => node["ipaddress"],
               :db_domain => db_domain
  })
  owner oracle_user
  group oracle_group
  mode "0664"
end

template "/etc/init.d/oracle" do
  source "oracle.erb"
  variables ({
               :oracle_sid => oracle_sid
  })
  owner oracle_user
  group oracle_group
  mode "0751"
  notifies :run, "execute[register_hook]", :immediately
end

execute "register_hook" do
  command "chkconfig --add oracle"
  action :nothing
end
