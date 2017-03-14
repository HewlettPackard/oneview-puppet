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

require 'spec_helper'

provider_class = Puppet::Type.type(:image_streamer_artifact_bundle).provider(:image_streamer)
api_version = login_image_streamer[:api_version] || 300
resource_name = 'ArtifactBundle'
resourcetype = Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context Image Streamer'

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:download_path) { '/path/fake-path' }

  let(:test) do
    resource['data']['uri'] = '/rest/artifact-bundles/123'
    resource['data']['artifactsbundleID'] = '123'
    resourcetype.new(@client, resource['data'])
  end

  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_artifact_bundle).new(
        name: 'artifact-bundle-1',
        ensure: 'present',
        data:
            {
              'name'        => 'Artifact_Bundle_Puppet',
              'description' => 'Artifact Bundle with a Plan Script Artifact',
              'buildPlans' => [{
                'resourceUri' => 'BuildPlanName',
                'readOnly'    => false
              }, {
                'resourceUri' => '/rest/build-plans/id',
                'readOnly'    => false
              }],
              'deploymentPlans' => [{
                'resourceUri' => 'DeploymentPlanName',
                'readOnly'    => false
              }, {
                'resourceUri' => '/rest/deployment-plans/id',
                'readOnly'    => false
              }],
              'goldenImages' => [{
                'resourceUri' => 'GoldenImageName',
                'readOnly'    => false
              }, {
                'resourceUri' => '/rest/golden-images/id',
                'readOnly'    => false
              }],
              'planScripts' => [{
                'resourceUri' => 'PlanScriptName',
                'readOnly'    => false
              }, {
                'resourceUri' => '/rest/plan-scripts/id',
                'readOnly'    => false
              }]
            }
      )
    end

    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])

      build_plan = OneviewSDK::ImageStreamer::BuildPlan.new(@client, 'name' => 'BuildPlanName', 'uri' => '/rest/uri/fake-bp')
      allow(OneviewSDK::ImageStreamer::BuildPlan).to receive(:find_by).with(anything, name: 'BuildPlanName').and_return([build_plan])

      deploym = OneviewSDK::ImageStreamer::DeploymentPlan.new(@client, 'name' => 'DeploymentPlanName', 'uri' => '/rest/uri/fake-dp')
      allow(OneviewSDK::ImageStreamer::DeploymentPlan).to receive(:find_by).with(anything, name: 'DeploymentPlanName').and_return([deploym])

      golden_image = OneviewSDK::ImageStreamer::GoldenImage.new(@client, 'name' => 'GoldenImageName', 'uri' => '/rest/uri/fake-gi')
      allow(OneviewSDK::ImageStreamer::GoldenImage).to receive(:find_by).with(anything, name: 'GoldenImageName').and_return([golden_image])

      plan_script = OneviewSDK::ImageStreamer::PlanScript.new(@client, 'name' => 'PlanScriptName', 'uri' => '/rest/uri/fake-ps')
      allow(OneviewSDK::ImageStreamer::PlanScript).to receive(:find_by).with(anything, name: 'PlanScriptName').and_return([plan_script])

      provider.exists?
    end

    it 'should be an instance of the provider image_streamer' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_artifact_bundle).provider(:image_streamer)
    end

    it 'should create artifact bundle when not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect_any_instance_of(resourcetype).to receive(:create).and_return(test)
      expect(provider.create).to be
    end

    it 'should rename artifact bundle when resource exists and new_name provided' do
      resource['data']['new_name'] = 'Artifact_Bundle_Renamed'
      provider.exists?
      expect_any_instance_of(resourcetype).to receive(:update_name).with('Artifact_Bundle_Renamed')
      expect(provider.create).to be
    end

    it 'should do nothing when resource exists and no new_name' do
      expect_any_instance_of(resourcetype).not_to receive(:update_name)
      expect(provider.create).to be
    end

    it 'should delete the resource' do
      allow_any_instance_of(resourcetype).to receive(:delete).and_return([])
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'should create artifact bundle from file when not exists' do
      resource['data'] = { 'name' => 'Artifact_Bundle_Puppet', 'artifact_bundle_path' => 'artifact_bundle.zip' }
      provider.exists?
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(resourcetype).to receive(:create_from_file).with(anything, 'artifact_bundle.zip', 'Artifact_Bundle_Puppet').and_return(test)
      expect(provider.create).to be
    end

    it 'should extract the artifact bundle' do
      expect_any_instance_of(resourcetype).to receive(:extract).and_return(true)
      expect(provider.extract).to be
    end

    context 'given the download ensurable' do
      before(:each) do
        resource['data']['artifact_bundle_download_path'] = download_path
      end

      context 'when file does not exist' do
        before(:each) do
          allow(File).to receive(:exist?).with(download_path).and_return(false)
          expect_any_instance_of(resourcetype).to receive(:download).with(download_path).and_return(true)
        end

        it 'should download the file' do
          expect(provider.download).to be
        end

        it 'should download if force is false' do
          resource['data']['force'] = false
          expect(provider.download).to be
        end

        it 'should download if force is true' do
          resource['data']['force'] = true
          expect(provider.download).to be
        end
      end

      context 'when file already exists' do
        before(:each) do
          allow(File).to receive(:exist?).with(download_path).and_return(true)
        end

        it 'should raise error' do
          expect_any_instance_of(resourcetype).not_to receive(:download).and_return(true)
          expect { provider.download }.to raise_error('File /path/fake-path already exists.')
        end

        it 'should raise error if force is false' do
          resource['data']['force'] = false
          expect_any_instance_of(resourcetype).not_to receive(:download).and_return(true)
          expect { provider.download }.to raise_error('File /path/fake-path already exists.')
        end

        it 'should download if force is true' do
          resource['data']['force'] = true
          expect_any_instance_of(resourcetype).to receive(:download).with(download_path).and_return(true)
          expect(provider.download).to be
        end
      end
    end
  end

  context 'given the backup operations' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_artifact_bundle).new(
        name: 'artifact-bundle-1',
        ensure: 'present',
        data:
            {
              'deploymentGroupUri' => deployment_group_uri
            }
      )
    end

    let(:deployment_group_uri) { '/rest/deployment-groups/2ed047b6-b8c2-4779-b6b8-e855a995513f' }

    let(:group) { OneviewSDK::ImageStreamer::DeploymentGroup.new(@client, 'uri' => deployment_group_uri) }

    let(:message_group_not_found) { /Deployment Group has not been found in the Appliance./ }

    let(:message_group_undefined) { /A 'deploymentGroupUri' field is required in the data hash to run this action./ }

    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      group_data = { 'uri' => deployment_group_uri }
      allow(OneviewSDK::ImageStreamer::DeploymentGroup).to receive(:find_by).with(anything, group_data).and_return([group])
    end

    context 'given the get_backups ensurable' do
      it 'should display the backup data' do
        test['data'] = { 'downloadURI' => '/rest/artifact-bundles/backups/archive/3aa193b2-9cd9-44fc-a140-ff917db74312' }
        expect(resourcetype).to receive(:get_backups).with(anything).and_return([test])
        expect(provider.get_backups).to be
      end
    end

    context 'given the extract_backup ensurable' do
      it 'should extract the existing backup bundle' do
        expect(resourcetype).to receive(:extract_backup).with(anything, group, 'uri' => '/archive').and_return(true)
        expect(provider.extract_backup).to be
      end

      it 'should raise error when group undefined' do
        resource['data'] = { 'name' => 'value' }
        provider.exists?
        expect { provider.extract_backup }.to raise_error(message_group_undefined)
      end
    end

    context 'given the create_backup ensurable' do
      it 'should create a backup bundle with all the artifacts present on the appliance' do
        expect(resourcetype).to receive(:create_backup).with(anything, group).and_return('uri' => '/rest/fake/backup.zip')
        expect(provider.create_backup).to be
      end

      it 'should raise error when group undefined' do
        resource['data'] = { 'name' => 'value' }
        provider.exists?
        expect(resourcetype).not_to receive(:create_backup)
        expect { provider.create_backup }.to raise_error(message_group_undefined)
      end
    end

    context 'given the download_backup ensurable' do
      before(:each) do
        resource['data']['backup_download_path'] = download_path
        test['data'] = { 'downloadURI' => '/rest/artifact-bundles/backups/archive/3aa193b2-9cd9-44fc-a140-ff917db74312' }
        allow(resourcetype).to receive(:get_backups).and_return([test])
      end

      context 'when file does not exist' do
        before(:each) do
          allow(File).to receive(:exist?).with(download_path).and_return(false)
          expect(resourcetype).to receive(:download_backup).with(anything, download_path, test).and_return(true)
        end

        it 'should download the file' do
          expect(provider.download_backup).to be
        end

        it 'should download if force is false' do
          resource['data']['force'] = false
          expect(provider.download_backup).to be
        end

        it 'should download if force is true' do
          resource['data']['force'] = true
          expect(provider.download_backup).to be
        end
      end

      context 'when file already exists' do
        before(:each) do
          allow(File).to receive(:exist?).with(download_path).and_return(true)
        end

        it 'should raise error' do
          expect(resourcetype).not_to receive(:download_backup)
          expect { provider.download_backup }.to raise_error('File /path/fake-path already exists.')
        end

        it 'should raise error if force is false' do
          resource['data']['force'] = false
          expect(resourcetype).not_to receive(:download_backup)
          expect { provider.download_backup }.to raise_error('File /path/fake-path already exists.')
        end

        it 'should download if force is true' do
          resource['data']['force'] = true
          expect(resourcetype).to receive(:download_backup).with(anything, download_path, test).and_return(true)
          expect(provider.download_backup).to be
        end
      end
    end

    context 'given the create_backup_from_file ensurable' do
      it 'should create backup upload and extract the file content' do
        resource['data']['backup_upload_path'] = '/path/fake_file.zip'
        fake_hash = { 'uri' => '/rest/fake/backup.zip' }
        filepath = '/path/fake_file.zip'
        filename = 'fake_file.zip'
        expect(resourcetype).to receive(:create_backup_from_file!).with(anything, group, filepath, filename, 21_600).and_return(fake_hash)
        expect(provider.create_backup_from_file).to be
      end

      it 'create_backup_from_file should raise error when group undefined' do
        resource['data'] = { 'name' => 'value' }
        provider.exists?
        expect(resourcetype).not_to receive(:create_backup_from_file!)
        expect { provider.create_backup_from_file }.to raise_error(message_group_undefined)
      end
    end
  end
end
