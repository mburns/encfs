require_relative 'spec_helper'

describe 'test::destroy' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['encfs']).converge(described_recipe) }

  before do
    stub_command('mountpoint /mnt/test').and_return(true)
    stub_command("grep '/mnt/test' /etc/mtab").and_return(true)
    stub_command('fusermount -u /mnt/test').and_return(true)
  end

  it "deletes '/mnt/test'" do
    expect(chef_run).to delete_directory('/mnt/test')
  end

  it "deletes '/opt/crypt/#{Digest::SHA256.hexdigest('/mnt/test')}'" do
    expect(chef_run).to delete_directory("/opt/crypt/#{Digest::SHA256.hexdigest('/mnt/test')}")
  end
end
