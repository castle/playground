class UsersController < Clearance::UsersController
  def create
    super

    if @user.errors.empty?
      env['castle'].identify(
        @user.id,
        {
          created_at: @user.created_at,
          email: @user.email
        }
      )
    end
  end
end
