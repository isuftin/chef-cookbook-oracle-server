#
# Cookbook Name:: owi-oracle-server
# Recipe:: install_client
#
# Description:: Install the Oracle client
#

rpm_package 'Install Oracle Instant Client RPM' do
  source node['owi-oracle-server']['config']['basic_client_install_location']
  action :upgrade
end

rpm_package 'Install Oracle JDBC RPM' do
  source node['owi-oracle-server']['config']['jdbc_client_install_location']
  action :upgrade
end

rpm_package 'Install Oracle SQLPlus  RPM' do
  source node['owi-oracle-server']['config']['sqlplus_client_install_location']
  action :upgrade
end
