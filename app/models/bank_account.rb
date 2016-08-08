class BankAccount < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  has_many :budgets
  validates :bank_account_number,uniqueness: true, presence: true, length: { is: 10 }
  after_create :generate_annual_budget

  def total_transactions_sum_by_category_and_month(category:, month_start:, month_end:)
    self.transactions.joins(:tag).where("tags.category = :category AND transactions.created_at >= :start_date AND transactions.created_at <= :end_date", {category: category, start_date: month_start, end_date: month_end }).sum(:amount)
  end

  def get_tag_transactions_sum(tag_description)
    self.transactions.joins(:tag).where('tags.description': tag_description).sum(:amount)
  end

  def generate_annual_budget
    12.times do |number|
      month = Date::MONTHNAMES[number + 1]
      self.budgets.create(name: month, start_date: Date.parse(month), end_date: Date.parse(month).end_of_month)
    end
  end
  
end
