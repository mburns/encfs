#
# Cookbook Name:: test
# Recipe:: destroy
#
# License:: Apache License, Version 2.0
#

encfs '/mnt/test' do
  action :destroy
end
