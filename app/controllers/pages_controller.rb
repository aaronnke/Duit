class PagesController < ApplicationController
  before_action :set_bank_account, only: [:profile, :dashboard]

  def profile
  
  @users = User.all 

    #------------------ budgets -------------------#
    unless current_user.bank_accounts.empty?
      if current_user.bank_accounts.first.budgets.empty?
        @budget = @bank_account.budgets.new
      else
        set_budgets
      end
    end

    #------------------ groups -------------------#
    if current_user.groups.empty?
      @group = Group.new
    else
      @group = current_user.groups.first
    end

  end


  def dashboard

    @transaction = Transaction.new

    set_budgets

    set_transactions

  end


  private

  def set_bank_account
    if current_user.bank_accounts.empty?
      @bank_account = BankAccount.new
    else
      @bank_account = current_user.bank_accounts.first
    end
  end

 def set_budgets

   if current_user.groups.empty?
     @group_users = [current_user]
   else
     @group_users = current_user.groups.first.users
   end

   @budget = []
   @budget_incomes = []
   @budget_expenses = []
   @budget_balances = []
   @total_budget_income = []
   @total_budget_expense = []
   @total_budget_balance = []

     @group_users.each.with_index do |user, index|
     @budget << user.bank_accounts.first.budgets.last
     @budget_incomes << @budget[index].get_incomes
     @budget_expenses << @budget[index].get_expenses
     @budget_balances << @budget[index].get_balances
     @total_budget_income << @budget_incomes[index].sum(:amount)
     @total_budget_expense << @budget_expenses[index].sum(:amount)
     @total_budget_balance << @budget_balances[index].sum(:amount)
   end

 end

  def set_transactions

    @transactions = @bank_account.transactions
    @total_income_transaction = @bank_account.total_income_transaction
    @total_expense_transaction = @bank_account.total_expense_transaction
    @total_balance_transaction = @bank_account.total_balance_transaction

  end


end
