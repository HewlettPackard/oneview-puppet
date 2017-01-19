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

# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    api_version = 300
    options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: api_version }
    @client = OneviewSDK::Client.new(options)
  end
end

RSpec.shared_context 'integration context', a: :b do
  # Context for integration testing:
  # WARNING: Communicates with & modifies a real instance.
  # Must set the following environment variables:
  ENV['ONEVIEW_INTEGRATION_CONFIG'] ||= 'spec/integration/oneview_config.json'
  ENV['ONEVIEW_INTEGRATION_SECRETS'] ||= 'spec/integration/oneview_secrets.json'
  begin
    JSON.parse(File.read(File.absolute_path(ENV['ONEVIEW_INTEGRATION_CONFIG'])), symbolize_names: true)
    JSON.parse(File.read(File.absolute_path(ENV['ONEVIEW_INTEGRATION_SECRETS'])), symbolize_names: true)
  rescue Errno::ENOENT
    raise 'No Integration Config and/or Secrets files have been found. Integration tests will not be able to run.'
  end
  # Ensure config & secrets files exist
  before :all do
    default_config  = 'spec/integration/oneview_config.json'
    default_secrets = 'spec/integration/oneview_secrets.json'

    @config_path  ||= ENV['ONEVIEW_INTEGRATION_CONFIG']  || default_config
    @secrets_path ||= ENV['ONEVIEW_INTEGRATION_SECRETS'] || default_secrets

    unless File.file?(@config_path) && File.file?(@secrets_path)
      STDERR.puts "\n\n"
      STDERR.puts 'ERROR: Integration config file not found' unless File.file?(@config_path)
      STDERR.puts 'ERROR: Integration secrets file not found' unless File.file?(@secrets_path)
      STDERR.puts "\n\n"
      exit!
    end

    $secrets ||= OneviewSDK::Config.load(@secrets_path) # Secrets for URIs, server/enclosure credentials, etc.

    # Create client objects:
    $config  ||= OneviewSDK::Config.load(@config_path)
    $client  ||= OneviewSDK::Client.new($config.merge(api_version: 200))
  end

  before :each do |e|
    if ENV['PRINT_METADATA_ONLY']
      # For debugging only: Shows test metadata without actually running the tests
      action = case e.metadata[:type]
               when CREATE then 'CREATE'
               when UPDATE then 'UPDATE'
               when DELETE then 'DELETE'
               else '_____'
               end
      puts "#{action} #{e.metadata[:sequence] || '_'}: #{described_class}: #{e.metadata[:description]}"
      raise 'Skipped'
    end
  end
end
