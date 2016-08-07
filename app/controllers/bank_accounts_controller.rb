class BankAccountsController < ApplicationController
	
	def new
		@bank_account = BankAccount.new
	end

	def create
		@bank_account = BankAccount.new(bank_account_params)
		 if @bank_account.save
			 redirect_to user_profile_path(current_user)
		 else
			 flash[:notice] = "Bank account already exists."
			 redirect_to user_profile_path(current_user)
		 end
	end

  def edit
  end

  def show
  end


private
  def bank_account_params
    params.require(:bank_account).permit(:bank_account_number, :pin, :user_id, :balance)
  end

end
