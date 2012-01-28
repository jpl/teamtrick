class ChangeUsersForAuthlogic < ActiveRecord::Migration
  def up
    change_column :users, :crypted_password, :string, :limit => 128, :null => false, :default => ""
    change_column :users, :salt, :string, :limit => 128, :default => ""
    
    rename_column :users, :remember_token, :persistence_token
  end

  def down
    rename_column :users, :persistence_token, :remember_token
  end
end
