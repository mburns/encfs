require_relative 'spec_helper'

describe 'test::mount' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['encfs']).converge(described_recipe) }

  before do
    stub_command('mountpoint /mnt/test').and_return(true)
    stub_command("echo 'SUPER SEKRIT' | encfs --standard \
                    --stdinpass /opt/crypt/#{Digest::SHA256.hexdigest('/mnt/test')} \
                    /mnt/test").and_return(true)
  end

  it 'installs fuse' do
    expect(chef_run).to install_package('fuse')
    expect(chef_run).to_not install_package('not_fuse')
  end

  it 'upgrades encfs' do
    expect(chef_run).to upgrade_package('encfs')
    expect(chef_run).to_not install_package('not_encfs')
  end

  it "creates '/mnt/test'" do
    expect(chef_run).to create_directory('/mnt/test').with(
      user: 'application',
      group: 'application'
    )
  end

  it "creates '/opt/crypt'" do
    expect(chef_run).to create_directory('/opt/crypt').with(
      user: 'root',
      group: 'root'
    )
  end

  it "creates '/opt/crypt/#{Digest::SHA256.hexdigest('/mnt/test')}'" do
    expect(chef_run).to create_directory("/opt/crypt/#{Digest::SHA256.hexdigest('/mnt/test')}").with(
      user: 'application',
      group: 'application'
    )
  end
end
