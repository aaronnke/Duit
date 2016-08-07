class PagesController < ApplicationController
  before_action :set_bank_account, only: [:profile, :dashboard]

  def profile
    #Donut Pie Chart
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Type' )
    data_table.new_column('number', 'Expenses')
    data_table.add_rows([
      ['Food', 20],
      ['Entertainment', 30],
      ['Mortgage', 30],
      ['Student Loan', 20]
    ])
    formatter = GoogleVisualr::NumberFormat.new( { :prefix => 'MYR ', :negativeColor => 'red', :negativeParens => true } )
    option = { width: 400, height: 240, pieHole: 0.6,legend: 'none', pieSliceText: 'none', colors: ['#88C057','#9777A8', '#ED7161', '#47A0DB']}
    @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
    formatter.columns(1) # Apply to 2nd Column
    data_table.format(formatter)    
    @progressbarnumber = [66,77,88,55]
    @colorarray = ["#88C057","#9777A8", "#ED7161", "#47A0DB"]
      

    #Line Graph
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Year')
    data_table.new_column('number', 'Budget')
    data_table.new_column('number', 'Actual')
    data_table.add_rows(4)
    data_table.set_cell(0, 0, '2004')
    data_table.set_cell(0, 1, 1000)
    data_table.set_cell(0, 2, 400)
    data_table.set_cell(1, 0, '2005')
    data_table.set_cell(1, 1, 1170)
    data_table.set_cell(1, 2, 460)
    data_table.set_cell(2, 0, '2006')
    data_table.set_cell(2, 1, 860)
    data_table.set_cell(2, 2, 580)
    data_table.set_cell(3, 0, '2007')
    data_table.set_cell(3, 1, 1030)
    data_table.set_cell(3, 2, 540)
    formatter = GoogleVisualr::NumberFormat.new( { :prefix => 'MYR ', :negativeColor => 'red', :negativeParens => true } )
    opts   = { :width => 400, :height => 240, :title => 'Savings Performance', :legend => 'bottom' }
    formatter.columns(1) # Apply to 2nd Column
    data_table.format(formatter)  
    @chart = GoogleVisualr::Interactive::LineChart.new(data_table, opts)

    






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
