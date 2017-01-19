################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'rspec-puppet/spec_helper'
require 'puppet'
require 'rspec'
require 'rspec-puppet'
require 'pry'
require 'simplecov'

provider_path = 'lib/puppet/provider'
type_path = 'lib/puppet/type'

SimpleCov.profiles.define 'unit' do
  add_filter 'spec/'
  add_group 'Providers', provider_path
  add_group 'Types', type_path
  minimum_coverage 80 # TODO: bump up as we increase coverage. Goal: 95%
  minimum_coverage_by_file 50 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'all' do
  add_filter 'spec/'
  add_group 'Providers', provider_path
  add_group 'Types', type_path
  minimum_coverage 50 # TODO: bump up as we increase coverage. Goal: 85%
  minimum_coverage_by_file 30 # TODO: bump up as we increase coverage. Goal: 70%
end

if RSpec.configuration.filter_manager.inclusions.rules[:unit]
  SimpleCov.start 'unit'
else # Run both
  SimpleCov.start 'all'
end

require 'oneview-sdk'
require_relative 'shared_context'
require_relative 'support/fake_response'
# require_relative 'integration/sequence_and_naming'
# require_relative 'system/light_profile/resource_names'

RSpec.configure do |config|
  # NOTE: Puppet specific declarations
  config.module_path  = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules'))
  # Using an empty site.pp file to avoid: https://github.com/rodjek/rspec-puppet/issues/15
  config.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
  # End of puppet specific declarations

  # Rspec output Configurations
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
  # End of Rspec output Configurations

  # Sort integration and system tests
  if config.filter_manager.inclusions.rules[:integration] || config.filter_manager.inclusions.rules[:system]
    config.register_ordering(:global) do |items|
      items.sort_by { |i| [(i.metadata[:type] || 0), (i.metadata[:sequence] || 100)] }
    end
  end

  config.before(:each) do
    # TODO: Puppet: Probably reverify this once we have have different test profiles
    if config.filter_manager.inclusions.rules[:unit]
      # Mock appliance version and login api requests, as well as loading trusted certs
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(300)
      allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')
      allow(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_return(nil)
    end

    # Clear environment variables
    %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).each do |name|
      ENV[name] = nil
    end
  end
end
