def whyrun_supported?
  true
end

def load_current_resource
  unless new_resource.encrypted_path
    new_resource.encrypted_path(
      ::File.join(
        node['encfs']['directories']['crypt'],
        Digest::SHA256.hexdigest(new_resource.visible_path)
      )
    )
  end
end

def setup_encfs
  directory node['encfs']['directories']['crypt'] do
    recursive true
    owner 'root'
    group 'root'
  end
  new_resource.updated_by_last_action(true)

  package 'fuse'
  package 'encfs'
  new_resource.updated_by_last_action(true)
end

action :mount do
  setup_encfs

  visible = new_resource.visible_path
  crypted = new_resource.encrypted_path
  password = new_resource.password

  unless password
    run_context.include_recipe 'encfs::passwords'
    if (fs_pass = node.run_state['encfs'][visible])
      password fs_pass
    else
      fail "EncFS requires a password for mounting directories! (path: #{visible})"
    end
  end

  [visible, crypted].each do |dir_name|
    directory dir_name do
      owner new_resource.owner
      group new_resource.group
      recursive true
    end
    new_resource.updated_by_last_action(true)
  end

  execute "EncFS mount <#{visible}>" do
    command "echo '#{password}' | encfs --standard --stdinpass #{crypted} #{visible}"
    not_if "mountpoint #{visible}"
  end
  new_resource.updated_by_last_action(true)
end

action :unmount do
  setup_encfs

  execute "EncFS unmount <#{new_resource.visible_path}>" do
    command "fusermount -u #{new_resource.visible_path}"
    not_if "grep '#{new_resource.visible_path}' /etc/mtab"
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

alias_method :action_create, :action_mount
alias_method :action_umount, :action_unmount
alias_method :action_delete, :action_destroy
