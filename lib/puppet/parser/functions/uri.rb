require 'oneview-sdk'
require File.expand_path(File.join(File.dirname(__FILE__), '../../provider', 'login'))

# This function gets the uri of the given resource
module Puppet::Parser::Functions
  newfunction(:uri, type: :rvalue) do |args|
    @client = OneviewSDK::Client.new(login)
    resourcetype = Object.const_get("OneviewSDK::#{args[1].to_s[0].upcase}#{args[1][1..args[1].size]}")
    resource = resourcetype.find_by(@client, name: args[0])
    resource.first['uri']
  end
end
