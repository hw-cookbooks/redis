if(node['redis']['replication']['redis_replication_role'] == 'slave')
  master = search(:node, 'redis_replication_role:master').first
  if(master)
    node.normal['redis']['config']['slaveof'] = "#{master['ipaddress']} #{master['redis']['config']['port']}"
    if(Gem::Version.new(node['redis']['installed_version']) >= Gem::Version.new('2.6.0'))
      node.normal['redis']['config']['slave_read_only'] = true
    end
  end
else
  node.normal['redis']['config']['bind'] = node.ipaddress
end

