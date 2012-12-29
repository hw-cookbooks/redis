#
# Cookbook Name:: redis
# Recipe:: _server_service

if(node.run_state[:seen_recipes].keys.include?('redis::server_source'))
  redis_service = 'redis-server'
else
  redis_service = case node['platform_family']
  when "debian"
    "redis-server"
  when "rhel", "fedora"
    "redis"
  else
    "redis"
  end
end

service "redis" do
  service_name redis_service
  action [ :enable, :start ]
end
