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
    @deployment_group_class = OneviewSDK::ImageStreamer.resource_named('DeploymentGroup', @client.api_version)
    super([nil, :found, :extract, :download])
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

  def extract
    artifact_bundle = get_single_resource_instance
    artifact_bundle.extract
    true
  end

  def download
    path = @data.delete('artifact_bundle_download_path')
    artifact_bundle = get_single_resource_instance
    artifact_bundle.download(path)
    true
  end

  def get_backups
    backups = @resourcetype.get_backups(@client)
    backups.each { |item| pretty item.data }
    true
  end

  def extract_backup
    @resourcetype.extract_backup(@client, get_deployment_group, 'uri' => '/archive')
    true
  end

  def create_backup
    @resourcetype.create_backup(@client, get_deployment_group)
    true
  end

  def create_backup_from_file
    path = @data.delete('backup_upload_path')
    @resourcetype.create_backup_from_file!(@client, get_deployment_group, path, File.basename(path), 21_600)
    true
  end

  def download_backup
    path = @data.delete('backup_download_path')
    backup = @resourcetype.get_backups(@client)
    @resourcetype.download_backup(@client, path, backup.first)
    true
  end

  def get_deployment_group
    deployment_group_uri = @data.delete('deploymentGroupUri')
    raise 'The \'deploymentGroupUri\' field is required in data hash to run this action.' unless deployment_group_uri
    deployment_groups = @deployment_group_class.find_by(@client, 'uri' => deployment_group_uri)
    raise 'Deployment Group has not been found in the Appliance.' if deployment_groups.empty?
    deployment_groups.first
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
