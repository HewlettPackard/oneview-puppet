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
def login
  begin
    # - Creating a JSON file with the proper fields and setting the environment variable ONEVIEW_AUTH_FILE to its path
    credentials = if ENV['ONEVIEW_AUTH_FILE']
                    JSON.parse(File.read(File.absolute_path(ENV['ONEVIEW_AUTH_FILE'])), symbolize_names: true)
                  # - Declaring each field as an environment variable
                  elsif ENV['ONEVIEW_URL']
                    environment_credentials
                  # - Placing a JSON file in the directory you are running the manifests from
                  else
                    JSON.parse(File.read(File.expand_path(Dir.pwd + '/login.json', __FILE__)), symbolize_names: true)
                  end
  rescue
    raise('The Oneview credentials could not be set. Please check the documentation for more information.')
  end
  credentials_parse(credentials)
end

# Returns the credentials set by environment variables
def environment_credentials
  {
    url:         ENV['ONEVIEW_URL'],
    ssl_enabled: ENV['ONEVIEW_SSL_ENABLED'],
    log_level:   ENV['ONEVIEW_LOG_LEVEL'] || 'info',
    api_version: ENV['ONEVIEW_API_VERSION'] || 200,
    token:       ENV['ONEVIEW_TOKEN'] || nil,
    user:        ENV['ONEVIEW_USER'] || nil,
    password:    ENV['ONEVIEW_PASSWORD'] || nil
  }
end

# Converts strings into booleans and returns the credentials ready to go
def credentials_parse(credentials)
  credentials.each do |key, value|
    credentials[key] = false if value == 'false'
    credentials[key] = true if value == 'true'
  end
  credentials
end
