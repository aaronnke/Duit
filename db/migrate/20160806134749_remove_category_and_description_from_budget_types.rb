class RemoveCategoryAndDescriptionFromBudgetTypes < ActiveRecord::Migration
  def change
    remove_column :budget_types, :description, :string
    remove_column :budget_types, :category, :string
  end
end
