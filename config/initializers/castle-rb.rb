Castle::Middleware.configure do |config|
  config.app_id = ENV['CASTLE_APP_ID']
  config.api_secret = ENV['CASTLE_API_SECRET']
end
