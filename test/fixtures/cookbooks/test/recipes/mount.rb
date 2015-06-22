#
# Cookbook Name:: test
# Recipe:: mount
#
# License:: Apache License, Version 2.0
#

user 'application'
group 'application' do
  members ['application']
end

encfs '/mnt/test' do
  owner 'application'
  group 'application'
  password 'SUPER SEKRIT'
  action :mount
end
