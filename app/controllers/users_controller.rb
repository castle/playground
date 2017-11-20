require 'castle/support/rails'

class UsersController < Clearance::UsersController
  def create
    super

    return if @user.errors.empty?

    castle.track(
      event: '$registration.succeeded',
      user_id: @user.id
    )
  end
end
