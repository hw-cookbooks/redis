if(node['redis']['replication']['redis_replication_role'] == 'slave')
  master = search(:node, 'redis_replication_role:master').first
  if(master)
    node.set['redis']['config']['slaveof'] = "#{master[:ipaddress]} #{master['redis']['config']['listen_port']}"
  end
else
  node[:redis][:config][:bind] = node.ipaddress
end

