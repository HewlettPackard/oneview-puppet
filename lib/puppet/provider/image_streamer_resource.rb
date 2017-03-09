################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

require_relative 'oneview_resource'

module Puppet
  # Base provider for Image Streamer resources
  class ImageStreamerResource < Puppet::OneviewResource
    desc 'Base provider for Image Streamer resources'

    def client
      self.class.client
    end

    def self.client
      credentials_set = ENV['ONEVIEW_AUTH_FILE'] || ENV['ONEVIEW_URL'] ||
                        File.exist?(File.expand_path(Dir.pwd + '/login.json', __FILE__))

      return OneviewSDK::Client.new(login).new_i3s_client(login_image_streamer) if credentials_set
      OneviewSDK::ImageStreamer::Client.new(login_image_streamer)
    end

    def ov_resource_type
      api_version = login_image_streamer[:api_version] || 300
      Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}")
    end

    def self.ov_resource_type
      api_version = login_image_streamer[:api_version] || 300
      Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}")
    end
  end
end
