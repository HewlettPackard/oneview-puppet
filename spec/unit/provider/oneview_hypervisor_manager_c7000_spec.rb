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

provider_class = Puppet::Type.type(:oneview_hypervisor_manager).provider(:c7000)

describe provider_class, unit: true do
  include_context 'shared context Hypervisor Manager'

  let(:resource) do
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

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { OneviewSDK::API800::C7000::HypervisorManager.new(@client, resource['data']) }

  context 'given the Creation parameters' do
    before(:each) do
      hypervisor_manager_type = OneviewSDK::API800::C7000::HypervisorManager
      allow(hypervisor_manager_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'runs through the create method' do
      hypervisor_manager_type = OneviewSDK::API800::C7000::HypervisorManager
      allow(hypervisor_manager_type).to receive(:find_by).and_return([])
      allow_any_instance_of(hypervisor_manager_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      hypervisor_manager_type = OneviewSDK::API800::C7000::HypervisorManager
      resource['data']['uri'] = '/rest/fake'
      allow(hypervisor_manager_type).to receive(:find_by).and_return([test])
      allow_any_instance_of(hypervisor_manager_type).to receive(:delete).and_return([])
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      hypervisor_manager_type = OneviewSDK::API800::C7000::HypervisorManager
      allow(hypervisor_manager_type).to receive(:find_by).and_return([test])
      expect(instance).to be
    end

    it 'finds the resource' do
      hypervisor_manager_type = OneviewSDK::API800::C7000::HypervisorManager
      allow(hypervisor_manager_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect(provider.found).to be
    end
  end
end
