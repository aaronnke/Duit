class PagesController < ApplicationController

  before_action :set_month, only: [:profile, :dashboard]
  before_action :set_user, only: [:profile, :dashboard]
  before_action :set_bank_account, only: [:profile, :dashboard]
  before_action :set_colors, only: [:dashboard]
  before_action :validate_dashboard_access, only: [:dashboard]


  def profile

    unless current_user.bank_accounts.empty?
      if current_user.bank_accounts.first.budgets.empty?
        @budget = @bank_account.budgets.new
      else
        set_group_users
        set_profile_budgets
      end
    end

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

    # PLEASE LOOK INTO THESE TWO METHODS TO SEE IF YOU NEED THEM. MY OVERVIEW DOES NOT NEED THEM ANYMORE.
    set_dashboard_budgets
    set_dashboard_transactions

    if @view == "Overview"
      set_overview_transactions
      set_overview_budgets
      set_overview_percentages

    elsif @view == "Income"
      set_actual_pie_charts(category: "income")

    elsif @view == "Expense"
      set_expense_everything   # THIS IS YOUR BUDGETED PIE CHART MAKING METHOD WHICH I REFACTORED INTO HERE.
      set_actual_pie_charts(category: "expense")

    elsif @view == "Balance"
      set_actual_pie_charts(category: "balance")

    end

  end


# ================================================================================ #
# ================================ Sub-methods =================================== #
# ================================================================================ #

  private

  def validate_dashboard_access
    if current_user.bank_accounts.empty?
      flash[:notice] = "Please register a bank account first."
      redirect_to user_profile_path
    end
  end

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
      @group_users = @group_users.sort_by { |user| user.allocations.find_by(group_id: current_user.groups.first.id) }
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


  def set_expense_everything
    @user1 = []
    @user2 = []
    @user3 = []
    @user4 = []

    def generatedata(budgettype)


      set_group_users.each_with_index do |user, index|

        user.bank_accounts.first.budgets.find_by(name: @parsed_month).budget_types.joins(:tag).where('tags.category': budgettype).each do |budget|

          if index == 0
            @user1 << [budget.tag.description, budget.amount]

          elsif index == 1


            @user2 << [budget.tag.description, budget.amount]

          elsif index == 2


            @user3 << [budget.tag.description, budget.amount]

          else

            @user4 << [budget.tag.description, budget.amount]
          end
        end
      end
    end



  def generateactualdata
    #this method will generate total amount sum of tag to all the users
  end

  #to display default value as expense
  if params[:budgettype].nil?
  theparams = "expense"
  else
  theparams = params[:budgettype]
  end

  generatedata(theparams)

  @progressbarnumber = [66,77,88,55]
  @colorarray = ["#88C057","#9777A8", "#ED7161", "#47A0DB"]
  width = 350
  height = 240
    #Budget Expense Pie Chart1
    data_table1 = GoogleVisualr::DataTable.new
    data_table1.new_column('string', 'Tag' )
    data_table1.new_column('number', 'Expenses')
    data_table1.add_rows(@user1)
    formatter = GoogleVisualr::NumberFormat.new( { :prefix => 'MYR ', :negativeColor => 'red', :negativeParens => true } )
    option1 = { width: width, height: height, pieHole: 0.6,legend: 'none', pieSliceText: 'none', colors: @colorarray}
    @chart1 = GoogleVisualr::Interactive::PieChart.new(data_table1, option1)
    formatter.columns(1) # Apply to 2nd Column
    data_table1.format(formatter)


    #Budget Expense Pie Chart2
    data_table2 = GoogleVisualr::DataTable.new
    data_table2.new_column('string', 'Tag' )
    data_table2.new_column('number', 'Expenses')
    data_table2.add_rows(@user2)
    formatter = GoogleVisualr::NumberFormat.new( { :prefix => 'MYR ', :negativeColor => 'red', :negativeParens => true } )
    option2 = { width: width, height: height, pieHole: 0.6,legend: 'none', pieSliceText: 'none', colors: @colorarray}
    @chart2 = GoogleVisualr::Interactive::PieChart.new(data_table2, option2)
    formatter.columns(1) # Apply to 2nd Column
    data_table2.format(formatter)


    #Budget Expense Pie Chart3
    data_table3 = GoogleVisualr::DataTable.new
    data_table3.new_column('string', 'Tag' )
    data_table3.new_column('number', 'Expenses')
    data_table3.add_rows(@user3)
    formatter = GoogleVisualr::NumberFormat.new( { :prefix => 'MYR ', :negativeColor => 'red', :negativeParens => true } )
    option3 = { width: width, height: height, pieHole: 0.6,legend: 'none', pieSliceText: 'none', colors: @colorarray}
    @chart3 = GoogleVisualr::Interactive::PieChart.new(data_table3, option3)
    formatter.columns(1) # Apply to 2nd Column
    data_table3.format(formatter)

    #Budget Expense Pie Chart4
    data_table4 = GoogleVisualr::DataTable.new
    data_table4.new_column('string', 'Tag' )
    data_table4.new_column('number', 'Expenses')
    data_table4.add_rows(@user4)
    formatter = GoogleVisualr::NumberFormat.new( { :prefix => 'MYR ', :negativeColor => 'red', :negativeParens => true } )
    option4 = { width: width, height: height, pieHole: 0.6,legend: 'none', pieSliceText: 'none', colors: @colorarray}
    @chart4 = GoogleVisualr::Interactive::PieChart.new(data_table4, option4)
    formatter.columns(1) # Apply to 2nd Column
    data_table4.format(formatter)
  end


  def set_colors
    @colors = ["#ef9a9a", "#ba68c8", "#f06292", "#c5e1a5", "#ffe082"]
  end


  def set_actual_pie_charts(category:)

    @all_user_data_array = []

    @bank_accounts = []

    @group_users.each do |user|
      @bank_accounts << user.bank_accounts.first
    end

    @bank_accounts.each do |bank_account|
      @user_data_array = []
      bank_account.budgets.find_by(name: @parsed_month).budget_types.joins(:tag).where('tags.category': category).each do |budget_type|
        tag_description = budget_type.tag.description
        temp_arr = []
        temp_arr << tag_description
        temp_arr << bank_account.total_transactions_sum_by_description_and_month(description: tag_description, month: Date.parse(@parsed_month))
        @user_data_array << temp_arr
      end
      @all_user_data_array << @user_data_array
    end
  end

end
