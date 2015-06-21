def whyrun_supported?
  true
end

def load_current_resource
  unless new_resource.visible_path
    new_resource.visible_path new_resource.name
  end

  unless new_resource.encrypted_path
    new_resource.encrypted_path(
      ::File.join(
        node['encfs']['directories']['crypt'],
        Digest::SHA.hexdigest(new_resource.visible_path)
      )
    )
  end
end

def setup_encfs
  directory node['encfs']['directories']['crypt'] do
    recursive true
  end

  package 'encfs'
end

action :mount do
  setup_encfs

  unless new_resource.password
    run_context.include_recipe 'encfs::passwords'
    if (fs_pass = node.run_state['encfs'][new_resource.visible_path])
      new_resource.password fs_pass
    else
      fail "EncFS requires a password for mounting directories! (path: #{new_resource.visible_path})"
    end
  end

  visible = new_resource.visible_path
  crypted = new_resource.encrypted_path

  [visible, crypted].each do |dir_name|
    directory dir_name do
      owner new_resource.owner
      group new_resource.group
      recursive true
    end
    new_resource.updated_by_last_action(true)
  end

  execute "EncFS mount <#{visible}>" do
    command "echo '#{new_resource.password} | encfs --standard --stdinpass #{crypted} #{visible}"
    not_if "mountpoint #{visible}"
  end
  new_resource.updated_by_last_action(true)
end

action :unmount do
  point = new_resource.visible_path

  mount "EncFS unmount <#{point}>" do
    path point
    action :umount
  end
  new_resource.updated_by_last_action(true)
end

action :destroy do
  visible = new_resource.visible_path
  crypted = new_resource.encrypted_path

  encfs visible do
    action :unmount
  end
  new_resource.updated_by_last_action(true)

  [visible, crypted].each do |dir_name|
    directory dir_name do
      action :delete
      recursive true
    end
    new_resource.updated_by_last_action(true)
  end
end
