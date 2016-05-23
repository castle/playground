class CastleHookController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_webhook

  def verify_webhook
    data = request.body.read
    hmac_header = request.headers["X-Castle-Signature"]
    digest  = OpenSSL::Digest::Digest.new('sha256')

    calculated_hmac =
    Base64.encode64(OpenSSL::HMAC.digest(
      digest,
      ENV["CASTLE_API_SECRET"],
      data)
    ).strip

    if calculated_hmac != hmac_header
      respond_to do |format|
        format.json { head :unauthorized }
      end
    end
  end

  def post
    # Retrieve the request's body and parse it as JSON
    auth = Castle::Authentication.new(JSON.parse(request.body.read))

    # Fetch the user from your database
    user = User.find(auth.user_id)

    if auth.risk > 0.9
      user.lock!
    elsif auth.risk > 0.3
      # Notify the user about unusual activity
      user.send_notification_email(auth)
    end

    render nothing: true, status: :ok
  end
end
