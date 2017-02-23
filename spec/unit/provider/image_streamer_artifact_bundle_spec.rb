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

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the Creation parameters with artifacts' do
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
      provider.exists?
      expect(provider.create).to be
    end

    it 'should rename artifact bundle when new name provided' do
      allow(resourcetype).to receive(:find_by).and_return([test])
      resource['data']['new_name'] = 'Artifact_Bundle_Renamed'
      provider.exists?
      expect_any_instance_of(resourcetype).to receive(:update_name).with('Artifact_Bundle_Renamed')
      expect(provider.create).to be
    end

    it 'should do nothing when no new_name' do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
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
  end

  context 'given the Creation parameters with a path' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_artifact_bundle).new(
        name: 'artifact-bundle-1',
        ensure: 'present',
        data:
            {
              'name'                 => 'Artifact_Bundle_Puppet',
              'artifact_bundle_path' => 'artifact_bundle.zip'
            }
      )
    end

    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should create artifact bundle from file when not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(resourcetype).to receive(:create_from_file).with(anything, 'artifact_bundle.zip', 'Artifact_Bundle_Puppet').and_return(test)
      provider.exists?
      expect(provider.create).to be
    end
  end
end
