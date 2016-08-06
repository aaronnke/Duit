class TransactionsController < ApplicationController

  def create
    @tag = Tag.find_by(category: params[:transaction][:tag])
    @tag = Tag.create(category: params[:transaction][:tag]) if @tag.nil?
    @transaction = Transaction.new(tag_id: @tag.id, amount: params[:transaction][:amount], bank_account_id: params[:bank_account_id])
    @transaction.save

    redirect_to user_dashboard_path(current_user.id)
  end

end
