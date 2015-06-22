require_relative 'spec_helper'

describe 'encfs::password' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
end
