class Budget < ActiveRecord::Base
  belongs_to :bank_account
  has_many :budget_types

  def get_incomes
    self.budget_types.where(category: "income")
  end

  def get_expenses
    self.budget_types.where(category: "expense")
  end

  def get_balances
    self.budget_types.where(category: "balance")
  end


end
