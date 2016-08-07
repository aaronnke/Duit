class PagesController < ApplicationController
  before_action :set_bank_account, only: [:profile, :dashboard]

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

    @user_index = 0

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
      @group_users = current_user
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

    if current_user.groups.empty?
      @group_users = [current_user]
    else
      @group_users = current_user.groups.first.users
    end

    @bank_accounts = []
    @transactions = []
    @total_income_transaction = []
    @total_expense_transaction = []
    @total_balance_transaction = []

    @group_users.each_with_index do |user, index|
      @bank_accounts << user.bank_accounts.first
      @transactions << @bank_accounts[index].transactions
      @total_income_transaction << @bank_accounts[index].total_income_transaction
      @total_expense_transaction << @bank_accounts[index].total_expense_transaction
      @total_balance_transaction << @bank_accounts[index].total_balance_transaction
    end

  end


  # def set_all_month_budgets
  #
  #   @all_month_budgets = []
  #
  #   @group_users.each do |user, index|
  #     @all_month_budgets << user.budgets
  #
  #     @all_month_budgets[index].each do |budget|
  #
  #     end
  #   end
  #
  # end


end
