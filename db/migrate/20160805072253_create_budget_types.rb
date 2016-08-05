class CreateBudgetTypes < ActiveRecord::Migration
  def change
    create_table :budget_types do |t|
      t.belongs_to :budget
      t.belongs_to :tag
      t.integer :amount
      t.string :category
      t.string :description

      t.timestamps null: false
    end
  end
end
