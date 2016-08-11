class TransactionsController < ApplicationController

  def create
    @tag = Tag.find_by(description: params[:transaction][:tag])

    unless @tag.nil?
      @transaction = Transaction.new(tag_id: @tag.id, amount: params[:transaction][:amount], bank_account_id: params[:bank_account_id], description: params[:transaction][:description])
      @transaction.save
      redirect_to user_dashboard_path(current_user.id)

    else
      flash[:notice] = "Tag doesn't exist. Please refer to tags from your budget."
      redirect_to(:back)
      # redirect_to user_dashboard_path(current_user.id)
    end

  end


end
