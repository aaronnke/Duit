class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :user_id
      t.float :balance
      t.integer :bank_account_number
      t.integer :pin
      t.timestamps null: false
    end
  end
end
