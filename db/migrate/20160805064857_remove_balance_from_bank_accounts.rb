class RemoveBalanceFromBankAccounts < ActiveRecord::Migration
  def change
    remove_column :bank_accounts, :balance, :float
  end
end
