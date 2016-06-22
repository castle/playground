Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = 'reply@example.com'
  config.sign_in_guards = [CastleRiskGuard]
end
