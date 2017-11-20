require 'castle/support/rails'

module Castle
  class HeaderFormatter
    def call(header)
      header.to_s.gsub(/^HTTP(?:_|-)/i, '').split(/_|-/).map(&:capitalize).join('-')
    end
  end
end

class SessionsController < Clearance::SessionsController
  before_filter :authorize, only: [:destroy]

  def create
    super
    if @user
      castle.authenticate(
        event: '$login.succeeded',
        user_id: @user.id
      )
    else
      email = params['session']['email']
      user = User.find_by_email(email)

      castle.track(
        event: '$login.failed',
        user_id: user && user.id,
        details: { email: email }
      )
    end
  end

  def destroy
    castle.track(
      user_id: current_user.id,
      event: '$logout.succeeded'
    )
    super
  end
end
