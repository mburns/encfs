#
# Cookbook Name:: test
# Recipe:: default
#
# License:: Apache License, Version 2.0
#

include_recipe 'test::mount'
include_recipe 'test::unmount'
include_recipe 'test::destroy'
