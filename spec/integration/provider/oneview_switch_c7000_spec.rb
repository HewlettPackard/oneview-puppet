################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_switch).provider(:c7000)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_switch).new(
      name: 'Switch',
      ensure: 'found',
      data:
          {
            'name' => '172.18.20.1'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_switch).provider(:c7000)
    end

    it 'exists? should find the Switch' do
      expect(provider.exists?).to be
    end

    it 'create should display unavailable method' do
      expect { provider.create }.to raise_error(/This ensurable is not supported for this resource/)
    end

    it 'should return that the Switch was found' do
      expect(provider.found).to be
    end

    it 'should be able to get the environmental configuration' do
      expect(provider.get_environmental_configuration).to be
    end

    it 'should drop the Switch' do
      expect(provider.destroy).to be
    end
  end

  context 'given no parameters for get types' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_type',
        provider: 'c7000'
      )
    end

    it 'should be able to get types' do
      provider.exists?
      expect(provider.get_type).to be
    end
  end

  context 'given a non existant switch name' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'absent',
        data:
            {
              'name'                      => '172.18.200.1'
            },
        provider: 'c7000'
      )
    end
    it 'exists? should not find the Switch' do
      expect(provider.exists?).not_to be
    end

    it 'should fail and return that the Switch was not found' do
      provider.exists?
      expect { provider.found }.to raise_error(/No Switch with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'present',
        data:
            {
              'name'                      => '172.18.20.1'
            },
        provider: 'c7000'
      )
    end
    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should display that no such type exists' do
      provider.exists?
      expect { provider.get_type }.to raise_error(/No switch types corresponding to the name 172.18.20.1 were found./)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_type',
        data:
            {
              'name'                      => 'Cisco Nexus 50xx'
            },
        provider: 'c7000'
      )
    end
    it 'should be able to get a specific type' do
      provider.exists?
      expect(provider.get_type).to be
    end
  end

  context 'given the parameters for getting statistics' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_statistics',
        data:
            {
              'name'                      => '172.18.20.1',
              'port_name'                 => '1.4',
              # 'subport_number'            => 'test'
            },
        provider: 'c7000'
      )
    end
    it 'should be able to get statistics' do
      provider.exists?
      expect(provider.get_statistics).to be
    end
  end
end
