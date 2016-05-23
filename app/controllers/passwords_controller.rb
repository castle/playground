class PasswordsController < Clearance::PasswordsController
  def update
    super
    @user.unlock!
  end
end
