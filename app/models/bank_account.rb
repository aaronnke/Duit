class BankAccount < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  has_many :budgets
  validates :bank_account_number,uniqueness: true, presence: true, length: { is: 10 }
  after_create :generate_annual_budget

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

  def generate_annual_budget
    self.budgets.create(name: "January", start_date: Date.parse("January"), end_date: Date.parse("January").end_of_month)
    self.budgets.create(name: "February", start_date: Date.parse("February"), end_date: Date.parse("February").end_of_month)
    self.budgets.create(name: "March", start_date: Date.parse("March"), end_date: Date.parse("March").end_of_month)
    self.budgets.create(name: "April", start_date: Date.parse("April"), end_date: Date.parse("April").end_of_month)
    self.budgets.create(name: "May", start_date: Date.parse("May"), end_date: Date.parse("May").end_of_month)
    self.budgets.create(name: "June", start_date: Date.parse("June"), end_date: Date.parse("June").end_of_month)
    self.budgets.create(name: "July", start_date: Date.parse("July"), end_date: Date.parse("July").end_of_month)
    self.budgets.create(name: "August", start_date: Date.parse("August"), end_date: Date.parse("August").end_of_month)
    self.budgets.create(name: "September", start_date: Date.parse("September"), end_date: Date.parse("September").end_of_month)
    self.budgets.create(name: "October", start_date: Date.parse("October"), end_date: Date.parse("October").end_of_month)
    self.budgets.create(name: "November", start_date: Date.parse("November"), end_date: Date.parse("November").end_of_month)
    self.budgets.create(name: "December", start_date: Date.parse("December"), end_date: Date.parse("December").end_of_month)
  end
end
