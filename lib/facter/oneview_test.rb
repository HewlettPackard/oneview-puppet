require_relative '../puppet/provider/login.rb'
require 'oneview-sdk'

def ov_defaults
  OneviewSDK.api_version = login[:api_version] || 300
  OneviewSDK::API300.variant = login[:hardware_variant] || 'C7000'
end

def ov_client
  OneviewSDK::Client.new(login)
end

def ov_initialize
  ov_defaults
  ov_client
end

def get_default_connection_template
  OneviewSDK::ConnectionTemplate.get_default(ov_client).data
end

Facter.add('oneview_test') do
  setcode do
    get_default_connection_template
  end
end
