unless(node['redis']['replication']['tunnel']['enabled'])
  node.default['redis']['config']['bind'] = node[:ipaddress]
end

if(node['redis']['replication']['redis_replication_role'] == 'slave')
  master = discovery_search(
    'redis_replication_role:master',
    :environment_aware => true,
    :raw_search => true,
    :minimum_response_time_sec => nil
  )

  if(master)
    if(node['redis']['replication']['tunnel']['enabled'])
      include_recipe 'stunnel'

      stunnel_connection 'redis' do
        connect "#{master['ipaddress']}:#{master['redis']['replication']['tunnel']['accept_port']}"
        accept "127.0.0.1:#{node['redis']['replication']['tunnel']['accept_port']}"
        notifies :restart, 'service[stunnel]'
      end

      node.normal['redis']['config']['slaveof'] = "127.0.0.1 #{node['redis']['replication']['tunnel']['accept_port']}"
    else
      node.normal['redis']['config']['slaveof'] = "#{master['ipaddress']} #{master['redis']['config']['port']}"
    end
  end
else
  if(node['redis']['replication']['tunnel']['enabled'])
    include_recipe 'stunnel::server'

    node.normal['redis']['config']['bind'] = '127.0.0.1'

    stunnel_connection 'redis' do
      accept node['redis']['replication']['tunnel']['accept_port']
      connect "#{node['redis']['config']['bind']}:#{node['redis']['config']['port']}"
      notifies :restart, 'service[stunnel]'
    end

    service "redis" do
      notifies :restart, 'service[stunnel]'
    end
  else
    node.normal['redis']['config']['bind'] = node[:ipaddress]
  end
end

