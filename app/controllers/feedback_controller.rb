class FeedbackController < ApplicationController
  
  def show
    jwt = params[:token]
    decoded = JWT.decode(jwt, ENV['CASTLE_API_SECRET'])
    feedback = decoded[0]
    @user = User.find(feedback['user_id'])
    @user.lock!
    @status = feedback['label']
  end
end
