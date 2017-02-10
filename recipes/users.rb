#
# Cookbook Name:: owi-oracle-server
# Recipe:: users
#
# Description:: Creates the required service user(s) and group(s)
#
oracle_user_home = '/home/oracle'
oracle_node_config = node['owi-oracle-server']['config']
oracle_user = oracle_node_config['oracle_user']
oracle_group = oracle_node_config['oracle_group']
oracle_home = oracle_node_config['oracle_home']
oracle_base = oracle_node_config['oracle_base']
oracle_sid = oracle_node_config['oracle_sid']
ld_path = oracle_node_config['ld_library_path']
databag_name = oracle_node_config['data_bag']['name']
credentials_item_name = oracle_node_config['data_bag']['item']['credentials']
system_password = ''
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  begin
    if search(databag_name, "id:#{credentials_item_name}").any?
      credentials_item = data_bag_item(databag_name, credentials_item_name)
      system_password = credentials_item['system_pass']
    end
  rescue
    Chef::Log.info('Data bag not found for writing system password. This is not necessarily an error if only the client is being installed')
  end
end

group oracle_group do
  append true
end

user oracle_user do
  group oracle_group
  manage_home true
end

group 'dba' do
  members oracle_user
  append true
end

# https://tickets.opscode.com/browse/CHEF-4976
execute "#{oracle_user}: disable password expiration" do
  command "chage -M 99999 '#{oracle_user}'"
  only_if do
    require 'shadow'
    Shadow::Passwd.getspnam(oracle_user).sp_max != 99_999
  end
end

template "#{oracle_user_home}/.bash_profile" do
  source 'oracle_bash_profile.erb'
  user oracle_user
  group oracle_group
  sensitive true
  variables(
    oracle_user_home: oracle_user_home,
    oracle_user: oracle_user,
    oracle_home: oracle_home,
    oracle_base: oracle_base,
    oracle_sid: oracle_sid,
    system_password: system_password,
    ld_path: ld_path
  )
  mode '0o744'
end

template "#{oracle_user_home}/.bashrc" do
  source 'oracle_bashrc.erb'
  user oracle_user
  group oracle_group
  sensitive true
  variables(
    oracle_user_home: oracle_user_home,
    oracle_user: oracle_user,
    oracle_home: oracle_home,
    oracle_base: oracle_base,
    oracle_sid: oracle_sid,
    system_password: system_password,
    ld_path: ld_path
  )
  mode '0o744'
end
