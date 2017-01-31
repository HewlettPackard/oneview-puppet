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

# you must have the interconnect in your appliance

provider_class = Puppet::Type.type(:oneview_sas_interconnect).provider(:synergy)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_sas_interconnect).new(
      name: 'interconnect',
      ensure: 'present',
      data:
       {
         'name'  => 'Encl1, interconnect 1',
         'patch' =>
        {
          'op'    => 'replace',
          'path'  => '/uidState',
          'value' => 'Off'
        },
         'refreshState' => 'RefreshPending'
       },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the min parameters' do
    before(:each) do
      provider.exists?
    end

    it 'should be an instance of the provider Synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_sas_interconnect).provider(:synergy)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should return the interconnects' do
      expect(provider.found).to be
    end

    it 'should raise errors for unsupported ensure methods' do
      expect { provider.create }.to raise_error('This resource relies on others to be created.')
      expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
    end

    it 'should be able to get a specific type' do
      resource['name'] = 'test'
      expect(provider.get_types).to be
    end

    it 'should be able to set a refresh state' do
      expect(provider.set_refresh_state).to be
    end
  end

  context 'With an empty data field' do
    let(:resource) do
      Puppet::Type.type(:oneview_sas_interconnect).new(
        name: 'interconnect',
        ensure: 'get_types',
        provider: 'synergy'
      )
    end
    before(:each) do
      provider.exists?
    end

    it 'should be able to get all types' do
      provider.exists?
      expect(provider.get_types).to be
    end
  end
end
