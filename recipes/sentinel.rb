include_recipe 'redis::replication'

basics = {
  :down_after_milliseconds => node[:redis][:sentinel][:down_after],
  :failover_timeout => node[:redis][:sentinel][:failover_timeout],
  :can_failover => node[:redis][:sentinel][:can_failover],
  :parallel_syncs => node[:redis][:sentinel][:parallel_syncs]
}

if(node['redis']['replication']['redis_replication_role'] == 'slave')
  master = search(:node, 'redis_replication_role:master').first
  if(master)
    node.default[:redis][:sentinel][:mon_config][master.name] = {
      :monitor => "#{master[:ipaddress]} #{master[:redis][:config][:port]} #{node[:redis][:sentinel][:quorum]}"
    }.merge(basics)
  else
    Chef::Log.warn 'Failed to locate redis master instance'
  end
else
  node.default[:redis][:sentinel][:mon_config][node.name] = {
    :monitor => "#{node[:ipaddress]} #{node[:redis][:config][:port]} #{node[:redis][:sentinel][:quorum]}"
  }.merge(basics)
end

template File.join(node[:redis][:conf_dir], 'sentinel.conf') do
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
