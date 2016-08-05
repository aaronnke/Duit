class RemoveBankAccountNumberFromBankAccounts < ActiveRecord::Migration
  def change
    remove_column :bank_accounts, :bank_account_number, :integer
  end
end
