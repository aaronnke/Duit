class PagesController < ApplicationController

  def profile
    unless current_user.bank_accounts.empty?
      if current_user.bank_accounts.first.budgets.empty?
        @budget = current_user.bank_accounts.first.budgets.new(budget_params)
      else
        @budget = current_user.bank_accounts.first.budgets.last
      end

      @incomes = @budget.get_incomes
      @expenses = @budget.get_expenses
      @balances = @budget.get_balances
    end

  end

  private

  def budget_params
    params.require(:budget).permit(:start_date, :end_date)
  end

end
