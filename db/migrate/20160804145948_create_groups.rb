class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.integer :master_id
      t.timestamps null: false
    end
  end
end
