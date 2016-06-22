class UserMailer < ApplicationMailer
  layout 'mail'

  def challenge(user, challenge_token)
    @user = user
    @challenge_token = challenge_token
    mail(to: user.email, subject: 'Is this you?')
  end
end
