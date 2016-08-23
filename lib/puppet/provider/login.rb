################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

require 'json'

# This method returns the information necessary in order to log in to the Oneview Appliance
# The three possible ways of declaring the variables are, respectively:
# - Creating a JSON file with the proper fields and setting the environment variable ONEVIEW_AUTH_FILE to its path
# - Declaring each field as an environment variable
# - Placing a JSON file in the manifests directory
def login
  credentials = {}
  if ENV['ONEVIEW_AUTH_FILE']
    credentials = JSON.parse(File.read(File.absolute_path(ENV['ONEVIEW_AUTH_FILE'])), symbolize_names: true)
  elsif ENV['ONEVIEW_URL']
    credentials_assignment_env_var(credentials)
  else
    require_relative 'manifests/credentials'
    credentials = JSON.parse(File.read(File.absolute_path(ENV['ONEVIEW_AUTH_FILE'])), symbolize_names: true)
  end
  raise('You need to specify your credentials. Please check the documentation for more information.') unless credentials
  credentials_parse(credentials)
end

def credentials_parse(credentials)
  credentials.each do |key, value|
    credentials[key] = false if value == 'false'
    credentials[key] = true if value == 'true'
  end
  # credentials[:logger] = Logger.new(STDOUT)
  credentials
end

def credentials_assignment_env_var(credentials)
  credentials[:url]         = ENV['ONEVIEW_URL']
  credentials[:user]        = ENV['ONEVIEW_USER']
  credentials[:password]    = ENV['ONEVIEW_PASSWORD']
  credentials[:ssl_enabled] = ENV['ONEVIEW_SSL_ENABLED']
  credentials[:logger]      = ENV['ONEVIEW_LOGGER']
  credentials[:log_level]   = ENV['ONEVIEW_LOG_LEVEL']
  credentials[:api_version] = ENV['ONEVIEW_API_VERSION'] || 200
  credentials[:token]       = ENV['ONEVIEW_TOKEN']
  credentials
end
