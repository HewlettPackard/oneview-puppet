require 'oneview-sdk'
require 'pry'

module Puppet::Parser::Functions
  newfunction(:connection_create) do |args|
    url      = args[0]
    username = args[1]
    password = args[2]

    @client = OneviewSDK::Client.new(
      url: url,
      user: username,
      password: password,
      ssl_enabled: false
    )

    puts "Connected to OneView appliance at #{@client.url}\n\n"
  end
end
