class BudgetsController < ApplicationController
  def create
    @budget = current_user.bank_accounts.first.budgets.new(budget_params)
    @budget.save

    redirect_to user_profile_path(current_user)
  end



  private

  def budget_params
    params.require(:budget).permit(:start_date, :end_date)
  end

end
