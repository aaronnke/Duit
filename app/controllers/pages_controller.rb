class PagesController < ApplicationController

  def profile

  data_table = GoogleVisualr::DataTable.new
  data_table.new_column('string', 'Type' )
  data_table.new_column('number', 'Expenses')

  formatter = new GoogleVisualr::DataTable.new({decimalSymbol: ',',groupingSymbol: '.', negativeColor: 'red', negativeParens: true, prefix: '$ '});


# Add Rows and Values
data_table.add_rows([
    ['Food', formatter.format(1000)],
    ['Entertainment', formatter.format(1170)],
    ['Mortgage', formatter.format(660)],
    ['Student Loan', formatter.format(1030)]
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

  def dashboard
    @bank_account = current_user.bank_accounts.first
    @transaction = Transaction.new
    @transactions = @bank_account.transactions
  end

end
