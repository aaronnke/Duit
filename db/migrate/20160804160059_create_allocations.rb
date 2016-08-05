class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at

        # t.belongs_to :user, index: true
#       t.belongs_to :group, index: true
      # t.timestamps null: false
    end
  end
end
