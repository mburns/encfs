actions :mount, :unmount, :destroy, :create, :umount, :delete
default_action :mount

attribute :encrypted_path, kind_of: String
attribute :name, kind_of: String, name_attribute: true
attribute :owner, kind_of: String, default: 'root'
attribute :group, kind_of: String, default: 'root'
attribute :password, kind_of: String

alias_method :visible_path, :name
