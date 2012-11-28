# Valid configuration values depend on version of
# redis installed. So version dependent defaults
# are set here

ruby_block 'Set redis config defaults' do
  block do
    ver_installed = Gem::Version.new(node[:redis][:installed_version])
    ver_24 = Gem::Version.new('2.4.0')
    ver_26 = Gem::Version.new('2.6.0')
    if(ver_installed < ver_26)
      node.default['redis']['config']['hash_max_zipmap_entries'] = 64
      node.default['redis']['config']['hash_max_zipmap_value'] = 512
      node.default['redis']['config']['vm_enabled'] = false
      node.default['redis']['config']['vm_max_memory'] = 0
      node.default['redis']['config']['vm_max_threads'] = 4
      node.default['redis']['config']['vm_page_size'] = 32
      node.default['redis']['config']['vm_pages'] = 134217728
      node.default['redis']['config']['vm_swap_file'] = "/var/lib/redis/redis.swap"
    else
      node.default['redis']['config']['list_max_ziplist_entries'] = 512
      node.default['redis']['config']['list_max_ziplist_value'] = 64
      node.default['redis']['config']['rdbchecksum'] = true
    end
    if(ver_installed >= ver_24)
      node.default['redis']['config']['slowlog_log_slower_than'] = 10000
      node.default['redis']['config']['slowlog_max_len'] = 1024
      node.default['redis']['config']['maxmemory_samples'] = 3
      node.default['redis']['config']['no_appendfsync_on_rewrite'] = false
      node.default['redis']['config']['set_max_intset_entries'] = 512
    end
  end
end
