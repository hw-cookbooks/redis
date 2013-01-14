#
# Cookbook Name:: redis
# Recipe:: _server_install_from_package

case node['platform_family']
when "debian"
  node.default['redis']['package_name'] = "redis-server"
when "rhel", "fedora"
  include_recipe "yum::epel"
  node.default['redis']['package_name'] = "redis"
else
  node.default['redis']['package_name'] = "redis"
end

Array(node['redis']['package_name']).each do |r_pkg|
  package r_pkg
end
