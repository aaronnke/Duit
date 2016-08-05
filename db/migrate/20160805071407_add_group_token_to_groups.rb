class AddGroupTokenToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_token, :string
  end
end
