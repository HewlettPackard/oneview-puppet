################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_hypervisor_cluster_profile).provider(:c7000)
api_version = 1800
resource_type = OneviewSDK.resource_named(:HypervisorClusterProfile, api_version, :C7000)
hm_type = OneviewSDK.resource_named(:HypervisorManager, api_version, :C7000)
spt_type = OneviewSDK.resource_named(:ServerProfileTemplate, api_version, :C7000)
dp_type = OneviewSDK.resource_named(:OSDeploymentPlan, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context Hypervisor Cluster Profile'
  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_hypervisor_cluster_profile).new(
        name: 'hcp1',
        ensure: 'present',
        data:
            {
              'type' => 'HypervisorClusterProfileV3',
              'name' => 'Cluster5',
              'hypervisorManagerUri' => '/rest/hypervisor-managers/befc6bd9-0366-4fd9-a3fc-c92ab0df3603',
              'path' => 'DC2',
              'hypervisorType' => 'Vmware',
              'hypervisorHostProfileTemplate' =>
              {
                'serverProfileTemplateUri' => '/rest/server-profile-templates/c865a62c-8fd8-414c-8c16-3f7ca75ab2ba',
                'deploymentPlan' =>
                {
                  'deploymentPlanUri' => '/rest/os-deployment-plans/c54e1dab-cc14-48fa-92bf-d301671fb0cf',
                  'serverPassword' => 'dcs'
                },
                'hostprefix' => 'Test-Cluster-host'
              }
            },
        provider: 'c7000'
      )
    end

    let(:hm_resource) do
      Puppet::Type.type(:oneview_hypervisor_manager).new(
        name: 'hm',
        ensure: 'present',
        data:
            {
              'name' => '172.18.13.11',
              'username' => 'dcs',
              'password' => 'dcs'
            },
        provider: 'c7000'
      )
    end

    let(:spt_resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'present',
        data:
              {
                'name'                  => 'SPT',
                'enclosureGroupUri'     => '/rest/',
                'serverHardwareTypeUri' => '/rest/',
                'description'           => 'description',
                'connectionSettings'    =>
                {
                  'manageConnections'   => true,
                  'connections'         =>
                  [
                    {
                      'id'              => 3,
                      'networkUri'      => '/rest/',
                      'functionType'    => 'Ethernet'
                    }
                  ]
                },
                'osDeploymentSettings' =>
                {
                  'complianceControl' => 'Checked'
                }
              },
        provider: 'c7000'
      )
    end

    let(:dp_resource) do
      Puppet::Type.type(:oneview_os_deployment_plan).new(
        name: 'os_deployment_plan',
        ensure: 'found',
        data:
            {
              'name' => 'OS_DP1'
            },
        provider: 'synergy'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, resource['data']) }

    let(:hm_test) { resource_type.new(@client, hm_resource['data']) }

    let(:spt_test) { resource_type.new(@client, spt_resource['data']) }

    let(:dp_test) { resource_type.new(@client, dp_resource['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(hm_type).to receive(:find_by).and_return([hm_test])
      allow(spt_type).to receive(:find_by).and_return([spt_test])
      allow(dp_type).to receive(:find_by).and_return([dp_test])
      provider.exists?
    end

    it 'should be an instance of the provider oneview_hypervisor_cluster_profile' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_hypervisor_cluster_profile).provider(:c7000)
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      spt_resource['data']['osDeploymentSettings']['complianceControl'] = 'Checked'
      allow(spt_type).to receive(:find_by).with(anything, spt_resource['data']).and_return([spt_test])
      allow(dp_type).to receive(:find_by).and_return([])
      resource['data']['hypervisorManagerUri'] = ['/rest/fake']
      resource['data']['hypervisorHostProfileTemplate']['serverProfileTemplateUri'] = '/rest/fake'
      resource['data']['hypervisorHostProfileTemplate']['deploymentPlan']['deploymentPlanUri'] = '/rest/fake'
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])

      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'set dp' do
      allow(resource_type).to receive(:find_by).and_return([])
      resource['data']['hypervisorHostProfileTemplate'] = ''
      allow(spt_type).to receive(:find_by).with(anything, spt_resource['data']).and_return([spt_test])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'runs through the create method with set_dp' do
      allow(resource_type).to receive(:find_by).and_return([])
      spt_resource['data']['osDeploymentSettings']['complianceControl'] = 'Checked'
      allow(spt_type).to receive(:find_by).with(anything, spt_resource['data']).and_return([spt_test])
      allow(dp_type).to receive(:find_by).and_return([])
      resource['data']['hypervisorManagerUri'] = ['/rest/fake']
      resource['data']['hypervisorHostProfileTemplate']['serverProfileTemplateUri'] = 'c865a62c-8fd8-414c-8c16-3f7ca75ab2ba'
      resource['data']['hypervisorHostProfileTemplate']['deploymentPlan']['deploymentPlanUri'] = '/rest/fake'
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])

      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      resource['data']['force'] = true
      resource['data']['softDelete'] = false
      allow(resource_type).to receive(:find_by).and_return([test])
      allow_any_instance_of(resource_type).to receive(:delete).with(resource['data']['softDelete'],
                                                                    resource['data']['force']).and_return([])
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      allow(resource_type).to receive(:find_by).and_return([test])
      expect(instance).to be
    end

    it 'finds the resource' do
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect(provider.found).to be
    end
  end
end
