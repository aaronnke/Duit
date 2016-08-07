class BankAccount < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  has_many :budgets
  validates :bank_account_number,uniqueness: true, presence: true, length: { is: 10 }

  def total_income_transaction
    self.transactions.joins(:tag).where('tags.category': 'income').sum(:amount)
  end

  def total_expense_transaction
    self.transactions.joins(:tag).where('tags.category': 'expense').sum(:amount)
  end

  def total_balance_transaction
    self.transactions.joins(:tag).where('tags.category': 'balance').sum(:amount)
  end

  def get_tag_transactions_sum(tag_description)
    self.transactions.joins(:tag).where('tags.description': tag_description).sum(:amount)
  end

end
