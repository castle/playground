class AccountsController < ApplicationController
  before_filter :require_login

  def update
    if current_user.update_attributes params.require(:user).permit(:description)
      redirect_to account_path, notice: 'Saved!'
    else
      redirect_to account_path, notice: 'Something went wrong.'
    end
  end
end
