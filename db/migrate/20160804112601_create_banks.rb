class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :content_service_id
      t.string :content_service_display_name
      t.integer :site_id
      t.string :site_display_name
      t.string :mfa
      t.string :home_url
      t.string :container

      t.timestamps null: false
    end
  end
end
