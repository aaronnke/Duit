class AddBalanceToBankAccounts < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :balance, :float, :precision => 2, scale: 2
   end
end
