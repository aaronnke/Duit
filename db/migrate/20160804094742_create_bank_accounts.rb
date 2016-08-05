class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.belongs_to :user
      t.float :balance
      t.integer :bank_account_number
      t.integer :pin
      t.timestamps null: false
    end
  end
end
