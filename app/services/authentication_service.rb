class AuthenticationService

  def self.resolve(castle, user, castle_authentication_id)
    authentication = Authentication.find_by(
      castle_authentication_id: castle_authentication_id
    )
    authentication = AuthenticationService.create_from_castle(
      castle,
      user
    ) unless authentication
    
    authentication
  end

  def self.create_from_castle(castle, user)
    castle_authentication = castle.authentications.create(user_id: user.id)
    authentication = Authentication.create(
      user: user,
      castle_authentication_id: castle_authentication.id
    )
    
    if castle_authentication.risk > 0.9
      user.lock!
    elsif castle_authentication.risk > 0.6
      challenge = authentication.create_challenge
      user.notify_user_with_challenge(challenge)
    end
    authentication.save
    authentication
  end
end
