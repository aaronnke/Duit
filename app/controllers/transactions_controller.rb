class TransactionsController < ApplicationController

  def create
    @tag = Tag.find_by(description: params[:transaction][:tag])

    unless @tag.nil?
      @transaction = Transaction.new(tag_id: @tag.id, amount: params[:transaction][:amount], bank_account_id: params[:bank_account_id], description: params[:transaction][:description])
      @transaction.save
      redirect_to user_dashboard_path(current_user.id)

    else
      flash[:notice] = "Tag doesn't exist. Please refer to tags from your budget."
      redirect_to user_dashboard_path(current_user.id)
    end

    if @tag.category == "income"
      @account = BankAccount.find_by(user_id: current_user.id)
      @new_balance = @transaction.bank_account.balance + @transaction.amount 
      @account.balance = @new_balance
      @account.save 
    else 
      @account = BankAccount.find_by(user_id: current_user.id)
      @new_balance = @transaction.bank_account.balance - @transaction.amount 
      @account.balance = @new_balance
      @account.save 
    end
      
  end


end
