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

     
    #groups 
    if current_user.groups.empty? 
      @group = Group.new 
    else 
      @group = current_user.groups.first 
    end 

  end

end
