class PasswordsController < Clearance::PasswordsController
  def update
    @user = find_user_for_update

    if @user.update_password password_reset_params
      @user.unlock!
      sign_in_without_castle_guard @user
      redirect_to url_after_update
    else
      flash_failure_after_update
      render template: 'passwords/edit'
    end
  end
end
