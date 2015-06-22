#
# Cookbook Name:: test
# Recipe:: default
#
# License:: Apache License, Version 2.0
#

include_recipe 'encfs'

user 'application'

encfs '/mnt/test' do
  owner 'application'
  group 'application'
  password 'SUPER SEKRIT'
  action :mount
end
