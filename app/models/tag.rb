class Tag < ActiveRecord::Base
  has_many :transactions
  has_many :budget_types
end
