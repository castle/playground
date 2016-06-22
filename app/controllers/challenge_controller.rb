SKIP_CASTLE_GUARD = false

class ChallengeController < ApplicationController
  def get
    challenge_token = params[:token]

    # TODO: Replace with real challenge token
    authentication = castle.authentications.find(challenge_token)
    if authentication
      user = User.find(authentication.user_id)
      sign_in(user)
      castle.track(
        name: '$login.succeeded',
        user_id: user.id)

      redirect_to account_path
    end
  end
end
