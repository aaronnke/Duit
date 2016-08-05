class AddBankAccountNumberToBankAccounts < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :bank_account_number, :string
  end
end
