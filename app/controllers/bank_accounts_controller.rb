class BankAccountsController < ApplicationController
	def new
		byebug
		@bankaccounts = BankAccount.new
	end	

	def create
		
		@bankaccounts = BankAccount.new(bankaccounts_params)
		@bankaccounts.save
	
	end

  	def edit
  	end

  	def show
  	end


private
  def bankaccounts_params

    permitted = params.require(:bank_account).permit(:bank_account_number, :pin, :user_id, :balance)
  end 

end
