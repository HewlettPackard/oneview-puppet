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

# This method returns the information necessary in order to log in to the Oneview Appliance
def login
  options = {
    type:         'OneView',
    file_env_var: 'ONEVIEW_AUTH_FILE',
    env_var_url:  'ONEVIEW_URL',
    filename:     '/login.json'
  }
  credentials = load_authentication_settings(options)
  credentials[:hardware_variant] ||= 'C7000'
  credentials
end

# This method returns the information necessary in order to log in to the Image Streamer Appliance
def login_image_streamer
  options = {
    type:         'Image Streamer',
    file_env_var: 'IMAGE_STREAMER_AUTH_FILE',
    env_var_url:  'IMAGE_STREAMER_URL',
    filename:     '/login_image_streamer.json'
  }
  load_authentication_settings(options)
end

def load_authentication_settings(options)
  begin
    # - Creating a JSON file with the proper fields and setting the environment variable with an auth file to its path
    credentials = if ENV[options[:file_env_var]]
                    JSON.parse(File.read(File.absolute_path(ENV[options[:file_env_var]])), symbolize_names: true)
                  # - Declaring each field as an environment variable
                  elsif ENV[options[:env_var_url]]
                    environment_credentials(options)
                  # - Placing a JSON file in the directory you are running the manifests from
                  else
                    JSON.parse(File.read(File.expand_path(Dir.pwd + options[:filename], __FILE__)), symbolize_names: true)
                  end
  rescue
    raise "The #{options[:type]} credentials could not be set. Please check the documentation for more information."
  end
  credentials_parse(credentials)
end

# Returns the credentials set by environment variables
def environment_credentials(options)
  options[:type] == 'OneView' ? environment_credentials_from_oneview : environment_credentials_from_image_streamer
end

def environment_credentials_from_oneview
  {
    url:                     ENV['ONEVIEW_URL'],
    ssl_enabled:             ENV['ONEVIEW_SSL_ENABLED'],
    log_level:               ENV['ONEVIEW_LOG_LEVEL'] || 'info',
    api_version:             ENV['ONEVIEW_API_VERSION'] ? ENV['ONEVIEW_API_VERSION'].to_i : 200,
    token:                   ENV['ONEVIEW_TOKEN'] || nil,
    user:                    ENV['ONEVIEW_USER'] || nil,
    password:                ENV['ONEVIEW_PASSWORD'] || nil,
    hardware_variant:        ENV['ONEVIEW_HARDWARE_VARIANT'] || 'C7000'
  }
end

def environment_credentials_from_image_streamer
  {
    url:                     ENV['IMAGE_STREAMER_URL'],
    ssl_enabled:             ENV['IMAGE_STREAMER_SSL_ENABLED'],
    log_level:               ENV['IMAGE_STREAMER_LOG_LEVEL'] || 'info',
    api_version:             ENV['IMAGE_STREAMER_API_VERSION'] ? ENV['IMAGE_STREAMER_API_VERSION'].to_i : 300,
    token:                   ENV['IMAGE_STREAMER_TOKEN'] || nil
  }
end

# Converts strings into booleans and returns the credentials ready to go
def credentials_parse(credentials)
  credentials.each do |key, value|
    credentials[key] = false if value == 'false'
    credentials[key] = true if value == 'true'
  end
end
