# load encfs passwords from encrypted data_bags
unless node.run_state['encfs']
  next unless node['encfs']['passwords']['data_bag']['enabled']

  begin
    unless node['encfs']['passwords']['data_bag']['encrypted']
      bag = data_bag_item(
        node['encfs']['passwords']['data_bag']['name'],
        node['encfs']['data_bag']['item']
      )
    end
    node.run_state['encfs'] = Mash.new(bag.to_hash)
  rescue 404
    Chef::Log.error('Failed to locate encfs password data bag!')
  end
end
