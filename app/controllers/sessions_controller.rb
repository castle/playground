class SessionsController < Clearance::SessionsController
  before_filter :authorize, only: [:destroy]

  def create
    super
    if @user
      castle.track(
        name: '$login.succeeded',
        user_id: @user.id)
    else
      email = params['session']['email']
      user_id = User.find_by_email(email).id rescue nil

      castle.track(
        name: '$login.failed',
        user_id: user_id,
        details: { '$login' => email })
    end
  end

  def destroy
    session[:authentication_id] = nil
    castle.track(
      user_id: current_user.id,
      name: '$logout.succeeded')
    super
  end
end
