class PagesController < ApplicationController
  before_action :set_bank_account

  def profile

    #------------------ budgets -------------------#
    if current_user.bank_accounts.first.budgets.empty?
      @budget = @bank_accounts.budgets.new
    else
      set_budgets
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

    @budget = current_user.bank_accounts.first.budgets.last
    @budget_incomes = @budget.get_incomes
    @budget_expenses = @budget.get_expenses
    @budget_balances = @budget.get_balances

    @total_budget_income = @budget_incomes.sum(:amount)
    @total_budget_expense = @budget_expenses.sum(:amount)
    @total_budget_balance = @budget_balances.sum(:amount)

  end

  def set_transactions

    @transactions = @bank_account.transactions
    @total_income_transaction = @bank_account.total_income_transaction
    @total_expense_transaction = @bank_account.total_expense_transaction
    @total_balance_transaction = @bank_account.total_balance_transaction

  end


end
