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

  confine feature: :oneview

  mk_resource_methods

  def exists?
    artifacts_uri_parse('buildPlans')
    artifacts_uri_parse('deploymentPlans')
    artifacts_uri_parse('goldenImages')
    artifacts_uri_parse('planScripts')
    super([nil, :found, :extract, :download])
  end

  def create
    current_resource = @resource_type.find_by(@client, unique_id).first
    if current_resource
      return true unless @data['new_name']
      current_resource.update_name(@data['new_name'])
    elsif @data['artifact_bundle_path']
      @data['timeout'] ||= OneviewSDK::Rest::READ_TIMEOUT
      @resource_type.create_from_file(@client, @data['artifact_bundle_path'], @data['name'], @data['timeout']).data
    else
      @resource_type.new(@client, @data).create.data
    end
  end

  def extract
    artifact_bundle = get_single_resource_instance
    artifact_bundle.extract
  end

  def download
    path = @data.delete('artifact_bundle_download_path')
    force = @data.delete('force')
    raise "File #{path} already exists." if File.exist?(path) && !force
    artifact_bundle = get_single_resource_instance
    artifact_bundle.download(path)
  end

  def get_backups
    backups = @resource_type.get_backups(@client)
    backups.each { |item| pretty item.data }
    true
  end

  def extract_backup
    @resource_type.extract_backup(@client, get_deployment_group, 'uri' => '/archive')
  end

  def create_backup
    @resource_type.create_backup(@client, get_deployment_group)
  end

  def create_backup_from_file
    path = @data.delete('backup_upload_path')
    @data['timeout'] ||= OneviewSDK::Rest::READ_TIMEOUT
    @resource_type.create_backup_from_file!(@client, get_deployment_group, path, File.basename(path), @data['timeout'])
  end

  def download_backup
    path = @data.delete('backup_download_path')
    force = @data.delete('force')
    raise "File #{path} already exists." if File.exist?(path) && !force
    backup = @resource_type.get_backups(@client)
    @resource_type.download_backup(@client, path, backup.first)
  end

  def get_deployment_group
    raise 'A \'deploymentGroupUri\' field is required in the data hash to run this action.' unless @data['deploymentGroupUri']
    @deployment_group_class = OneviewSDK::ImageStreamer.resource_named('DeploymentGroup', @client.api_version)
    @deployment_group_class.find_by(@client, 'uri' => @data['deploymentGroupUri']).first
  end

  def artifacts_uri_parse(artifacts_key)
    artifacts_list ||= resource['data'][artifacts_key]
    return unless artifacts_list
    resource_name = artifacts_key[0].capitalize + artifacts_key[1..-2]
    artifacts_list.each do |artifact|
      next if artifact['resourceUri'].include?('/rest/')
      artifact['resourceUri'] = "#{artifact['resourceUri']},#{resource_name}"
    end
  end
end
