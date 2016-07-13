require 'oneview-sdk'
require File.expand_path(File.join(File.dirname(__FILE__), '../../provider', 'login'))

# This function gets the uri of the given resource
module Puppet::Parser::Functions
  # Reminder: newfunction arguments are actually puppet's, and are not related
  # to the actual arguments to be treated by the function
  newfunction(:uri, type: :rvalue) do |args|
    @client = OneviewSDK::Client.new(login)
    # Assigning args to their correspondent variables
    name = args[0]
    type = args[1]
    resourcetype = Object.const_get("OneviewSDK::#{type}")
    resource = resourcetype.find_by(@client, name: name)
    resource.first['uri']
  end
end
