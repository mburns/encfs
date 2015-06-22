require_relative 'spec_helper'

describe 'test::unmount' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['encfs']).converge(described_recipe) }

  before do
    stub_command('mountpoint /mnt/test').and_return(true)
    stub_command("grep '/mnt/test' /etc/mtab").and_return(true)
    stub_command('fusermount -u /mnt/test').and_return(true)
  end
end
