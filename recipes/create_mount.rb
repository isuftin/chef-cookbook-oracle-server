#
# Cookbook Name:: owi-oracle-server
# Recipe:: create_mount
# Description:: Mounts a supposedly available drive
#

base_dir = node['owi-oracle-server']['config']['base_dir']
directory base_dir do
  recursive true
end

filesystem base_dir do
  fstype 'ext4'
  device node['owi-oracle-server']['config']['mount']['volume']
  mount base_dir
  action [:create, :enable, :mount]
end
