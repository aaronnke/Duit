class BankAccount < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  has_many :budgets
  validates :bank_account_number,uniqueness: true, presence: true, length: { is: 10 }

end
