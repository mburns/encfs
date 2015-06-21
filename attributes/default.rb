default['encfs']['directories']['crypt'] = '/opt/crypt'
default['encfs']['passwords']['data_bag']['enabled'] = true
default['encfs']['passwords']['data_bag']['encrypted'] = Chef::Config['encrypted_data_bag_secret']
default['encfs']['passwords']['data_bag']['name'] = 'encfs'
default['encfs']['passwords']['data_bag']['item'] = 'passwords'
