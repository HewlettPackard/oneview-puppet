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

require_relative '../image_streamer_resource'

Puppet::Type.type(:image_streamer_deployment_plan).provide :image_streamer, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer Deployment Plan using the Image Streamer API'

  mk_resource_methods

  def exists?
    super
    parse_build_plan
    parse_golden_image
    @resourcetype.find_by(@client, @data).any?
  end

  def parse_build_plan
    return unless @data['oeBuildPlanURI'] && !@data['oeBuildPlanURI'].include?('/rest/')
    build_plan_client = OneviewSDK::ImageStreamer.resource_named('BuildPlan', @client.api_version)
    resource = build_plan_client.find_by(@client, name: @data['oeBuildPlanURI'])
    raise 'Build Plan has not been found in the Appliance.' if resource.empty?
    @data['oeBuildPlanURI'] = resource.first['uri']
  end

  def parse_golden_image
    return unless @data['goldenImageURI'] && !@data['goldenImageURI'].include?('/rest/')
    golden_image_client = OneviewSDK::ImageStreamer.resource_named('GoldenImage', @client.api_version)
    resource = golden_image_client.find_by(@client, name: @data['goldenImageURI'])
    raise 'Golden Image has not been found in the Appliance.' if resource.empty?
    @data['goldenImageURI'] = resource.first['uri']
  end

  def resource_name
    'DeploymentPlan'
  end

  def self.resource_name
    'DeploymentPlan'
  end
end
