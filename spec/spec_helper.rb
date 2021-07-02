################################################################################
# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
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

require 'simplecov' # This needs to be imported before codecov/coveralls
require 'codecov'
require 'coveralls'
require 'oneview-sdk'
require 'pry'
require 'puppet'
require 'rspec'
require 'rspec-puppet'
require 'rspec-puppet/spec_helper'

require_relative 'shared_context'
require_relative 'support/fake_response'

provider_path = 'lib/puppet/provider'
type_path = 'lib/puppet/type'

Coveralls.wear!

SimpleCov.formatters = [SimpleCov::Formatter::Codecov, Coveralls::SimpleCov::Formatter, SimpleCov::Formatter::HTMLFormatter]

SimpleCov.profiles.define 'unit' do
  add_filter 'spec/'
  add_group 'Providers', provider_path
  add_group 'Types', type_path
  minimum_coverage 95 # TODO: bump up as we increase coverage. Goal: 100%
  minimum_coverage_by_file 70 # TODO: bump up as we increase coverage. Goal: 85%
end

SimpleCov.profiles.define 'all' do
  add_filter 'spec/'
  add_group 'Providers', provider_path
  add_group 'Types', type_path
end

RSpec.configure do |config|
  # Rspec-puppet specific configuration
  config.module_path  = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules'))
  config.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))

  # Rspec output Configurations
  config.color = true # Use color in STDOUT
  config.tty = true # Use color not only in STDOUT but also in pagers and files
  config.formatter = :documentation # Use the specified formatter (:progress, :html, :textmate)

  # Sort integration tests
  if config.filter_manager.inclusions.rules[:integration]
    config.register_ordering(:global) do |items|
      items.sort_by { |i| [(i.metadata[:type] || 0), (i.metadata[:sequence] || 100)] }
    end
  end

  # Set fake login files for unit tests
  if config.filter_manager.inclusions.rules[:unit]
    ENV['IMAGE_STREAMER_AUTH_FILE'] = 'spec/support/fixtures/unit/provider/login_image_streamer.json'
    ENV['ONEVIEW_AUTH_FILE'] = 'spec/support/fixtures/unit/provider/login_no_provider.json'
    SimpleCov.start 'unit' # Runs simplecov with minimum coverage relating to unit tests
  else # Run both
    SimpleCov.start 'all' # Runs simplecov with no coverage restrictions, applicable to integration tests
  end

  config.before(:each) do
    unless config.filter_manager.inclusions.rules[:integration] # If not using the integration flag, sets the mocks required for unit tests
      # Mock appliance version and login api requests, as well as loading trusted certs
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(3000)
      allow_any_instance_of(OneviewSDK::ImageStreamer::Client).to receive(:appliance_i3s_api_version).and_return(2020)
      allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')
      allow(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_return(nil)
    end

    # Clear environment variables
    %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).each do |name|
      ENV[name] = nil
    end
  end

  # Redirect stderr and stdout to Null
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    $stderr = File.open(File::NULL, 'w')
    $stdout = File.open(File::NULL, 'w')
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
