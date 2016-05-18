require 'oneview-sdk'
require 'pry'

module Puppet::Parser::Functions
  newfunction(:connection_create) do |args|

    ## Creates the Hash "options" using the arguments received
    options = args[0]

    @client = OneviewSDK::Client.new(
      url: options['appliance_adress'], # or set ENV['ONEVIEWSDK_URL']
      user: options['login'],  # or set ENV['ONEVIEWSDK_USER']
        password: options['password'],  # or set ENV['ONEVIEWSDK_PASSWORD']
      ssl_enabled: false
    )

    puts "Connected to OneView appliance at #{@client.url}\n\n"
  end
end
