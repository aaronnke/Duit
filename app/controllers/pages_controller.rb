class PagesController < ApplicationController

  def profile

    unless current_user.bank_accounts.empty?
      if current_user.bank_accounts.first.budgets.empty?
        @budget = current_user.bank_accounts.first.budgets.new
      else
        @budget = current_user.bank_accounts.first.budgets.last
      end

      @incomes = @budget.get_incomes
      @expenses = @budget.get_expenses
      @balances = @budget.get_balances

    else
      @bank_account = BankAccount.new
    end
  end

end
