class PagesController < ApplicationController
  before_action :set_month, only: [:profile, :dashboard]
  before_action :set_user, only: [:profile, :dashboard]
  before_action :set_bank_account, only: [:profile, :dashboard]


  def profile

    #------------------ budgets -------------------#
    unless current_user.bank_accounts.empty?
      if current_user.bank_accounts.first.budgets.empty?
        @budget = @bank_account.budgets.new
      else
        set_group_users
        set_profile_budgets
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


    @transaction = Transaction.new

   set_group_users

   set_dashboard_budgets

   set_dashboard_transactions

  end


# ================================================================================ #
# ================================ Sub-methods =================================== #
# ================================================================================ #

  private

  def set_month
    @month = (params[:month] ||= Date.today.month).to_i
    @parsed_month = Date::MONTHNAMES[@month]
  end


  def set_user
    if params[:user_id].present?
      if current_user.groups.empty?
        @user = current_user
        flash[:notice] = "You don't have that team member." if params[:user_id].to_i != current_user.id
      else
        if current_user.groups.first.users.where(id: params[:user_id].to_i).present?
          @user = User.find(params[:user_id])
        else
          @user = current_user
          flash[:notice] = "You don't have that team member."
        end
      end
    else
      @user = current_user
    end
  end


  def set_bank_account
    if @user.bank_accounts.empty?
      @bank_account = BankAccount.new
    else
      @bank_account = @user.bank_accounts.first
    end
  end


  def set_group_users
    if current_user.groups.empty?
      @group_users = [current_user]
    else
      @group_users = current_user.groups.first.users
    end
  end


  def set_profile_budgets

    @budget = []
    @budget_incomes = []
    @budget_expenses = []
    @budget_balances = []
    @total_budget_income = []
    @total_budget_expense = []
    @total_budget_balance = []

    @group_users.each.with_index do |user, index|
      @budget << user.bank_accounts.first.budgets.find_by(name: @parsed_month)
      @budget_incomes << @budget[index].get_incomes
      @budget_expenses << @budget[index].get_expenses
      @budget_balances << @budget[index].get_balances
      @total_budget_income << @budget_incomes[index].sum(:amount)
      @total_budget_expense << @budget_expenses[index].sum(:amount)
      @total_budget_balance << @budget_balances[index].sum(:amount)
    end

  end


  def set_dashboard_budgets

     @budget = @bank_account.budgets.find_by(name: @parsed_month)
     @budget_incomes = @budget.get_incomes
     @budget_expenses = @budget.get_expenses
     @budget_balances = @budget.get_balances
     @total_budget_income = @budget_incomes.sum(:amount)
     @total_budget_expense = @budget_expenses.sum(:amount)
     @total_budget_balance = @budget_balances.sum(:amount)

  end


  def set_dashboard_transactions

    month_start = Date.parse(@parsed_month).at_beginning_of_month
    month_end = Date.parse(@parsed_month).end_of_month
    @transactions = @bank_account.transactions.where(created_at: month_start..month_end)
    @total_income_transaction = @bank_account.total_transactions_sum_by_category_and_month(category: "income", month_start: month_start, month_end: month_end)
    @total_expense_transaction = @bank_account.total_transactions_sum_by_category_and_month(category: "expense", month_start: month_start, month_end: month_end)
    @total_balance_transaction = @bank_account.total_transactions_sum_by_category_and_month(category: "balance", month_start: month_start, month_end: month_end)

  end

end
