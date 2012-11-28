ruby_block 'store redis installation version' do
  block do
    node.normal['redis']['installed_version'] = %x{
      #{File.join(node['redis']['dst_dir'], 'bin/redis-server')} --version
    }.scan(/v=((\d+\.?){3})/).flatten.first
  end
end
