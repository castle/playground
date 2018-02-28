class SessionsController < Clearance::SessionsController
  before_filter :authorize, only: [:destroy]
  before_action do
    if current_user
      env['castle'].identify(
        current_user.id,
        {
          created_at: current_user.created_at,
          email: current_user.email
        }
      )
    end
  end

  def create
    super
    if @user
      env['castle'].identify(
        @user.id,
        {
          created_at: @user.created_at,
          email: @user.email
        }
      )
    else
      email = params['session']['email']
      user = User.find_by_email(email)

      env['castle'].identify(
        user.id,
        {
          created_at: user.created_at,
          email: user.email
        }
      )
    end
  end
end
