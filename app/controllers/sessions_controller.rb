LOCK_NOTICE = 'Your account is currently locked.
  Please follow the instructions in the email we\'ve sent.'.freeze

CHALLENGE_NOTICE = 'You need to verify your identity.
  Please follow the instructions in the email we\'ve sent.'.freeze

class SessionsController < Clearance::SessionsController
  before_filter :require_login, only: [:destroy]
  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        castle_authentication = castle.authentications.create(user_id: @user.id)
        
        if castle_authentication.risk > 0.9
          current_user.lock!
          castle.track(
            name: '$login.failed',
            user_id: @user.id,
            details: { '$login' => @user.email })
          sign_out
          
          flash.now.notice = LOCK_NOTICE
          render template: 'sessions/new', status: :unauthorized
        elsif castle_authentication.risk > 0.6
          current_user.challenge(castle_authentication)
          sign_out

          flash.now.notice = CHALLENGE_NOTICE
          render template: 'sessions/new', status: :unauthorized
        else
          castle.track(
            name: '$login.succeeded',
            user_id: @user.id)
          redirect_back_or url_after_create
        end
      else
        email = params['session']['email']
        user_id = User.find_by_email(email).id rescue nil
        castle.track(
          name: '$login.failed',
          user_id: user_id,
          details: { '$login' => email })
        
        flash.now.notice = status.failure_message
        render template: 'sessions/new', status: :unauthorized
      end
    end
  end

  def destroy
    castle.track(
      user_id: current_user.id,
      name: '$logout.succeeded')
    super
  end
end
