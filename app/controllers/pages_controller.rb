class PagesController < ApplicationController
  before_action :set_bank_account

  def profile

  data_table = GoogleVisualr::DataTable.new
  data_table.new_column('string', 'Type' )
  data_table.new_column('number', 'Expenses')

  # formatter = new GoogleVisualr::DataTable.new({decimalSymbol: ',',groupingSymbol: '.', negativeColor: 'red', negativeParens: true, prefix: '$ '});


# Add Rows and Values
data_table.add_rows([
    ['Food', 1000],
    ['Entertainment', 1170],
    ['Mortgage', 660],
    ['Student Loan', 1030]
])
option = { width: 400, height: 240, pieHole: 0.6,legend: 'none',pieSliceText: 'none'}

@chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)


    
    unless current_user.bank_accounts.empty?
      if current_user.bank_accounts.first.budgets.empty?
        @budget = current_user.bank_accounts.first.budgets.new
      else
        @budget = current_user.bank_accounts.first.budgets.last
      end

      @incomes = @budget.get_incomes
      @expenses = @budget.get_expenses
      @balances = @budget.get_balances


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
