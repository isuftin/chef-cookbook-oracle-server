#
# Cookbook Name:: owi-oracle-server
# Recipe:: update_useradd
# Description:: Updates useradd to dictate where new users will be created
#

template '/etc/default/useradd' do
  source 'useradd.erb'
  owner 'root'
  group 'root'
  variables('home_dir_root' => node['owi-oracle-server']['config']['user']['home_root'])
  mode 0o600
end
