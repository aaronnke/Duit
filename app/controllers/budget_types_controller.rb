class BudgetTypesController < ApplicationController

  def create_new_income
    @budget = Budget.find(params[:budget_id])
    @tag = Tag.create(params[:new_income][:tag])
    @income = @budget.budget_types.new(amount: params[:new_income][:amount], tag_id: @tag.id, category: "income")
    @budget.budget_types << @income

    redirect_to user_profile_path(current_user.id)
  end

  def create_new_expense
    @budget = Budget.find(params[:budget_id])
    @tag = Tag.create(params[:new_expense][:tag])
    @expense = @budget.budget_types.new(amount: params[:new_expense][:amount], tag_id: @tag.id, category: "expense")
    @budget.budget_types << @expense

    redirect_to user_profile_path(current_user.id)
  end

  def create_new_balance
    @budget = Budget.find(params[:budget_id])
    @tag = Tag.create(params[:new_balance][:tag])
    @balance = @budget.budget_types.new(amount: params[:new_balance][:amount], tag_id: @tag.id, category: "balance")
    @budget.budget_types << @balance

    redirect_to user_profile_path(current_user.id)
  end

end
