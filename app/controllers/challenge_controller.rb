class ChallengeController < ApplicationController
  def get
    castle_authentication_id = params[:authentication_id]
    challenge_token = params[:challenge_token]
    authentication = Authentication.find_by(
      castle_authentication_id: castle_authentication_id,
    )
    if authentication.challenge.resolve!(challenge_token)
      redirect_to account_path
    end
  end
end
