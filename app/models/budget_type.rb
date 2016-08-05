class BudgetType < ActiveRecord::Base
  belongs_to :budget
  belongs_to :tag
end
