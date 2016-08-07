class BudgetTypesController < ApplicationController
  before_action :set_budget

  def create_new_income
    @tag = Tag.find_by(description: params[:new_income][:tag])
    @tag = Tag.create(category: "income", description: params[:new_income][:tag]) if @tag.nil?
    @income = @budget.budget_types.create(amount: params[:new_income][:amount], tag_id: @tag.id)
    @budget.budget_types << @income

    redirect_to user_profile_path(current_user.id)
  end

  def create_new_expense
    @tag = Tag.find_by(description: params[:new_expense][:tag])
    @tag = Tag.create(category: "expense", description: params[:new_expense][:tag]) if @tag.nil?
    @expense = @budget.budget_types.new(amount: params[:new_expense][:amount], tag_id: @tag.id)
    @budget.budget_types << @expense

    redirect_to user_profile_path(current_user.id)
  end

  def create_new_balance
    @tag = Tag.find_by(description: params[:new_balance][:tag])
    @tag = Tag.create(category: "balance", description: params[:new_balance][:tag]) if @tag.nil?
    @balance = @budget.budget_types.new(amount: params[:new_balance][:amount], tag_id: @tag.id)
    @budget.budget_types << @balance

    redirect_to user_profile_path(current_user.id)
  end

  private

  def set_budget
    @budget = Budget.find(params[:budget_id])
  end

end
