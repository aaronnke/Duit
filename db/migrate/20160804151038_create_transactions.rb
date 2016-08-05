class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :bank_account, index: true
      t.belongs_to :tag, index: true
      t.integer :amount

      t.timestamps null: false
    end
  end
end
