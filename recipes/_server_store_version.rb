ruby_block 'store redis installation version' do
  block do
    node.normal['redis']['installed_version'] = %x{
      #{node['redis']['exec']} --version
    }.scan(/v=((\d+\.?){3})/).flatten.first
  end
end
