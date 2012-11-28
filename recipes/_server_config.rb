#
# Cookbook Name:: redis
# Recipe:: _server_config

include_recipe 'redis::_server_config_defaults'

directory node['redis']['conf_dir'] do
  owner "root"
  group "root"
  mode 0755
end

directory node['redis']['config']['dir'] do
  owner node['redis']['user']
  group node['redis']['group']
  mode 0755
end

unless(node['redis']['config']['logfile'] == 'stdout')
  directory File.dirname(node['redis']['config']['logfile']) do
    owner node['redis']['user']
    group node['redis']['group']
    recursive true
    mode 0755
  end
end

template "#{node['redis']['conf_dir']}/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[redis]", :immediate
end
