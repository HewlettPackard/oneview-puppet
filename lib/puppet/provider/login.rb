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

require 'json'

ONEVIEW_AUTH_FILE = 'ONEVIEW_AUTH_FILE'.freeze
ONEVIEW_URL = 'ONEVIEW_URL'.freeze
I3S_AUTH_FILE = 'I3S_AUTH_FILE'.freeze
I3S_URL = 'I3S_URL'.freeze

# This method returns the information necessary in order to log in to the Oneview Appliance
# The three possible ways of declaring the variables are, respectively:
def login
  begin
    # - Creating a JSON file with the proper fields and setting the environment variable ONEVIEW_AUTH_FILE to its path
    credentials = if ENV[ONEVIEW_AUTH_FILE]
                    load_credentials_from_file_env_var(ONEVIEW_AUTH_FILE)
                  # - Declaring each field as an environment variable
                  elsif ENV[ONEVIEW_URL]
                    environment_credentials
                  # - Placing a JSON file in the directory you are running the manifests from
                  else
                    load_credentials_from_file('/login.json')
                  end
  rescue
    raise('The Oneview credentials could not be set. Please check the documentation for more information.')
  end
  credentials_parse(credentials)
end

# This method returns the information necessary in order to log in to the Image Streamer Appliance
# The three possible ways of declaring the variables are, respectively:
def login_i3s
  begin
    # - Creating a JSON file with the proper fields and setting the environment variable I3S_AUTH_FILE to its path
    credentials = if ENV[I3S_AUTH_FILE]
                    load_credentials_from_file_env_var(I3S_AUTH_FILE)
                  # - Declaring each field as an environment variable
                  elsif ENV[I3S_URL]
                    environment_credentials_i3s
                  # - Placing a JSON file in the directory you are running the manifests from
                  else
                    load_credentials_from_file('/login_i3s.json')
                  end
  rescue
    raise('The Image Streamer credentials could not be set. Please check the documentation for more information.')
  end
  credentials_parse(credentials)
end

def load_credentials_from_file_env_var(variable_name)
  JSON.parse(File.read(File.absolute_path(ENV[variable_name])), symbolize_names: true)
end

def load_credentials_from_file(filename)
  JSON.parse(File.read(File.expand_path(Dir.pwd + filename, __FILE__)), symbolize_names: true)
end

# Returns the credentials set by environment variables
def environment_credentials
  {
    url:                     ENV['ONEVIEW_URL'],
    ssl_enabled:             ENV['ONEVIEW_SSL_ENABLED'],
    log_level:               ENV['ONEVIEW_LOG_LEVEL'] || 'info',
    api_version:             ENV['ONEVIEW_API_VERSION'] || 200,
    token:                   ENV['ONEVIEW_TOKEN'] || nil,
    user:                    ENV['ONEVIEW_USER'] || nil,
    password:                ENV['ONEVIEW_PASSWORD'] || nil,
    hardware_variant:        ENV['ONEVIEW_HARDWARE_VARIANT'] || 'C7000'
  }
end

# Returns the credentials set by environment variables
def environment_credentials_i3s
  {
    url:                     ENV['I3S_URL'],
    ssl_enabled:             ENV['I3S_SSL_ENABLED'],
    log_level:               ENV['I3S_LOG_LEVEL'] || 'info',
    api_version:             ENV['I3S_API_VERSION'] || 200,
    token:                   ENV['I3S_TOKEN'] || nil,
    hardware_variant:        'Synergy'
  }
end

# Converts strings into booleans and returns the credentials ready to go
def credentials_parse(credentials)
  credentials.each do |key, value|
    credentials[key] = false if value == 'false'
    credentials[key] = true if value == 'true'
  end
  credentials[:hardware_variant] ||= 'C7000'
  credentials
end
