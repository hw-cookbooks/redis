if(node['redis']['replication']['redis_replication_role'] == 'slave')
  master = search(:node, 'redis_replication_role:master')
  if(master)
    node.set['redis']['config']['slaveof'] = "#{master[:ipaddress]} #{master['redis']['config']['listen_port']}"
  end
end

