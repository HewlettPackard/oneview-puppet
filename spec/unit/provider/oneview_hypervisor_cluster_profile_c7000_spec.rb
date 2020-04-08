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
api_version = login[:api_version] || 800
resource_type = OneviewSDK.resource_named(:HypervisorClusterProfile, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

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
  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the Creation parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider oneview_hypervisor_cluster_profile' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_hypervisor_cluster_profile).provider(:c7000)
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      allow(resource_type).to receive(:find_by).and_return([test])
      allow_any_instance_of(resource_type).to receive(:delete).and_return([])
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
