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

Puppet::Type.type(:image_streamer_artifact_bundle).provide :image_streamer, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer Artifact Bundles using the Image Streamer API'

  mk_resource_methods

  def exists?
    artifacts_uri_parse('buildPlans')
    artifacts_uri_parse('deploymentPlans')
    artifacts_uri_parse('goldenImages')
    artifacts_uri_parse('planScripts')
    super([nil, :found])
  end

  def create
    current_resource = @resourcetype.find_by(@client, unique_id).first
    if current_resource
      current_resource.update_name(@data['new_name']) if @data['new_name']
    elsif @data['artifact_bundle_path']
      @resourcetype.create_from_file(@client, @data['artifact_bundle_path'], @data['name'])
    else
      @resourcetype.new(@client, @data).create
    end
    true
  end

  def artifacts_uri_parse(artifacts_key)
    artifacts_list ||= resource['data'][artifacts_key]
    artifacts_list ||= @data[artifacts_key]
    return unless artifacts_list
    resource_name = artifacts_key.slice(0, 1).capitalize + artifacts_key.slice(1..-2)
    artifacts_list.each do |artifact|
      next if artifact['resourceUri'].include?('/rest/')
      artifact['resourceUri'] = "#{artifact['resourceUri']},#{resource_name}"
    end
  end
end
