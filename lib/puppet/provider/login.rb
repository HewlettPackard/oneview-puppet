def login
  credentials = {
    url: ENV['ONEVIEW_URL'] ||= 'https://15.244.150.163',
    ssl_enabled: ['true', '1', 'yes'].include?(ENV['ONEVIEW_SSL_ENABLED']),
    logger: Logger.new(STDOUT),
    log_level: :info,
    log_level: ENV['ONEVIEW_LOG_LEVEL'] ||= 'info',
  }

  # Set EITHER token or the user & password
  if ENV['ONEVIEW_TOKEN']
    credentials[:token] = ENV['ONEVIEW_TOKEN']	
  else
    credentials[:user] = ENV['ONEVIEW_USER'] ||= 'Administrator'
    credentials[:password] = ENV['ONEVIEW_PASSWORD'] ||= 'chefoneview'
  end

  if ENV['ONEVIEW_API_VERSION']
    credentials[:api_version] = ENV['ONEVIEW_API_VERSION'].to_i
  else
    credentials[:api_version] = 200
  end

  credentials
end

