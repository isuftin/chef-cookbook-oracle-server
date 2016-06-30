#
# Cookbook Name:: owi-oracle-server
# Recipe:: default
#

include_recipe 'owi-oracle-server::dependencies'

include_recipe 'owi-oracle-server::users'

include_recipe 'owi-oracle-server::install_server'

include_recipe 'owi-oracle-server::start_stop_hooks'
