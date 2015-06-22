# encoding: UTF-8
# License:: Apache License, Version 2.0
#

require_relative 'spec_helper'

describe package('encfs') do
  it { should be_installed }
end

describe file('/opt/crypt') do
  it { should be_directory }
end
