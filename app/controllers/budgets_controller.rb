class BudgetsController < ApplicationController
  def create
    case params[:name]
    when "jan"
      @name = "Jan"
    when "feb"
      @name = "February"
    when "mar"
      @name = "March"
    when "apr"
      @name = "April"
    when "may"
      @name = "May"
    when "jun"
      @name = "June"
    when "jul"
      @name = "July"
    when "aug"
      @name = "August"
    when "sep"
      @name = "September"
    when "oct"
      @name = "October"
    when "nov"
      @name = "November"
    when "dec"
      @name = "December"
    end

    @start_date = Date.parse(@name)
    @end_date = Date.parse(@name).end_of_month
    @budget = current_user.bank_accounts.first.budgets.new(name: @name, start_date: @start_date, end_date: @end_date)
    @budget.save

    redirect_to user_profile_path(current_user)
  end



  # private
  #
  # def budget_params
  #   params.require(:budget).permit(:name, :start_date, :end_date)
  # end

end
