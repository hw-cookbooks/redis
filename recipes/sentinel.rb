if(node['redis']['replication']['tunnel']['enabled'])
  raise 'Sentinel is not currently supported with tunneled connections'
end

include_recipe 'redis::replication'

basics = {
  'down_after_milliseconds' => node['redis']['sentinel']['down_after'],
  'failover_timeout' => node['redis']['sentinel']['failover_timeout'],
  'can_failover' => node['redis']['sentinel']['can_failover'],
  'parallel_syncs' => node['redis']['sentinel']['parallel_syncs']
}

node.default['redis']['sentinel']['mon_config'][node.name] = {
  :monitor => "#{node['redis']['config']['bind']} #{node['redis']['config']['port']} #{node['redis']['sentinel']['quorum']}"
}.merge(basics)

template File.join(node['redis']['conf_dir'], 'sentinel.conf') do
  source 'sentinel.conf.erb'
  mode 0644
  notifies :restart, 'service[redis-sentinel]'
end

template '/etc/init.d/redis-sentinel' do
  source 'redis-sentinel_init.erb'
  mode 0755
end

service 'redis-sentinel' do
  action [:enable, :start]
end
