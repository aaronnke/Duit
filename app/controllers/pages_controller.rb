class PagesController < ApplicationController
  before_action :set_month, only: [:profile, :dashboard]
  before_action :set_user, only: [:profile, :dashboard]
  before_action :set_bank_account, only: [:profile, :dashboard]
  before_action :set_colors, only: [:dashboard]


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

    @view = params[:view] ||= "Overview"

    @transaction = Transaction.new

    set_group_users

    set_dashboard_budgets

    set_dashboard_transactions

    if @view == "Overview"
      set_overview_transactions
      set_overview_budgets
      set_overview_percentages
    end

    ### TO BE IMPLEMENTED TO SHOW PIE CHARTS: set_actual_pie_charts
    ### method is below.

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
    @total_income_transaction = @bank_account.total_transactions_sum_by_category_and_month(category: "income", month: Date.parse(@parsed_month))
    @total_expense_transaction = @bank_account.total_transactions_sum_by_category_and_month(category: "expense", month: Date.parse(@parsed_month))
    @total_balance_transaction = @bank_account.total_transactions_sum_by_category_and_month(category: "balance", month: Date.parse(@parsed_month))

  end


  def set_overview_transactions

    @overview_incomes_transaction = []
    @overview_expenses_transaction = []
    @overview_balances_transaction = []

    @group_users.each do |user|
      @overview_incomes_transaction << user.bank_accounts.first.total_transactions_sum_by_category_and_month(category: "income", month: Date.parse(@parsed_month))
      @overview_expenses_transaction << user.bank_accounts.first.total_transactions_sum_by_category_and_month(category: "expense", month: Date.parse(@parsed_month))
      @overview_balances_transaction << user.bank_accounts.first.total_transactions_sum_by_category_and_month(category: "balance", month: Date.parse(@parsed_month))
    end

  end


  def set_overview_budgets

    budgets = []
    @overview_incomes_budget = []
    @overview_expenses_budget = []
    @overview_balances_budget = []

    @group_users.each_with_index do |user, index|
      budgets << user.bank_accounts.first.budgets.find_by(name: @parsed_month)
      @overview_incomes_budget << budgets[index].get_incomes.sum(:amount)
      @overview_expenses_budget << budgets[index].get_expenses.sum(:amount)
      @overview_balances_budget << budgets[index].get_balances.sum(:amount)
    end

  end


  def set_overview_percentages

    @overview_incomes_percentage = []
    @overview_expenses_percentage = []
    @overview_balances_percentage = []

    @group_users.each_with_index do |user, index|

      unless @overview_incomes_budget[index] == 0
        @overview_incomes_percentage << (@overview_incomes_transaction[index].to_f/@overview_incomes_budget[index].to_f).round(2)*100
      else
        @overview_incomes_percentage << 0
      end

      unless @overview_expenses_budget[index] == 0
        @overview_expenses_percentage << (@overview_expenses_transaction[index].to_f/@overview_expenses_budget[index].to_f).round(2)*100
      else
        @overview_expenses_percentage << 0
      end

      unless @overview_balances_budget[index] == 0
        @overview_balances_percentage << (@overview_balances_transaction[index].to_f/@overview_balances_budget[index].to_f).round(2)*100
      else
        @overview_balances_percentage << 0
      end

    end

  end


  def set_colors
    @colors = ["#ef9a9a", "#ba68c8", "#f06292", "#c5e1a5", "#ffe082"]
  end


  def set_actual_pie_charts

    @all_user_data_array = []

    @bank_accounts = []

    @group_users.each do |user|
      @bank_accounts << user.bank_accounts.first
    end

    @bank_accounts.each do |bank_account|
      @user_data_array = []
      bank_account.budget.find_by(name: @parsed_month).budget_types.joins(:tag).where('tags.category': "income").each do |budget_type|
        tag_description = budget_type.tag.description
        temp_arr = []
        temp_arr << tag_description
        temp_arr << bank_account.total_transactions_sum_by_description_and_month(description: tag_description, month: @month)
        @user_data_array << temp_arr
      end
      @all_user_data_array << @user_data_array
    end
  end

end
