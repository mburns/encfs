#
# Cookbook Name:: test
# Recipe:: unmount
#
# License:: Apache License, Version 2.0
#

include_recipe 'test::mount'

e = encfs '/mnt/test' do
  owner 'application'
  group 'application'
  password 'SUPER SEKRIT'
  action :mount
end
e.run_action(:mount)

encfs '/mnt/test' do
  action :unmount
end
