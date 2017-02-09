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
  # Base provider for OneView resources
  class ImageStreamerResource < Puppet::OneviewResource
    desc 'Base provider for Image Streamer resources'

    def initialize(value = {})
      super(value)
    end

    def client
      OneviewSDK::ImageStreamer::Client.new(login_i3s)
    end

    def self.client
      OneviewSDK::ImageStreamer::Client.new(login_i3s)
    end

    def resource_name
      self.class.to_s.split('::')[2].split('_').drop(2).collect(&:capitalize).join
    end

    def self.resource_name
      to_s.split('::')[2].split('_').drop(2).collect(&:capitalize).join
    end

    def ov_resource_type
      api_version = login_i3s[:api_version] || 300
      Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}")
    end

    def self.ov_resource_type
      api_version = login_i3s[:api_version] || 300
      Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}")
    end
  end
end
