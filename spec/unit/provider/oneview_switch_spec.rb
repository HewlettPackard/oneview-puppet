################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_switch).provider(:oneview_switch)

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::Switch

  # TODO: #1 - a future improvement might be to make this test more atomic, by adding the
  # possibility to call creates to this test dependencies
  # TODO: #2 - This example is still using the ethernet_network_members.json file to generate
  # its json outputs. Ideally a switch specific json file should be used for cohesion.
  let(:resource) do
    Puppet::Type.type(:oneview_switch).new(
      name: 'Switch',
      ensure: 'found',
      data:
          {
            'name' => '172.18.20.1'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_switch' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_switch).provider(:oneview_switch)
    end

    it 'exists? should find the Switch' do
      expect(provider.exists?).to be
    end

    it 'create should display unavailable method' do
      expect(provider.exists?).to be
      expect { provider.create }.to raise_error(/This ensurable is not supported for this resource/)
    end

    it 'should return that the Switch was found' do
      test = OneviewSDK::Switch.new(@client, resource['data'])
      allow(OneviewSDK::Switch).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    it 'should be able to get types' do
      path = 'spec/support/fixtures/unit/provider/ethernet_network_members.json'
      teste = File.read(path)
      resource['data']['name'] = nil
      allow(OneviewSDK::Switch).to receive(:get_type).with(anything).and_return(['test'])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(teste))
      provider.exists?
      expect(provider.get_type).to be
    end

    it 'should be able to get the environmental configuration' do
      path = 'spec/support/fixtures/unit/provider/ethernet_network_members.json'
      teste = File.read(path)
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::Switch.new(@client, resource['data'])
      allow(OneviewSDK::Switch).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(teste))
      expect(provider.exists?).to eq(true)
      expect(provider.get_environmental_configuration).to be
    end

    it 'should drop the Switch' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::Switch.new(@client, resource['data'])
      allow(OneviewSDK::Switch).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.destroy).to be
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
            }
      )
    end
    it 'exists? should not find the Switch' do
      allow(OneviewSDK::Switch).to receive(:find_by).and_return([])
      expect(provider.exists?).not_to be
    end

    it 'should fail and return that the Switch was not found' do
      allow(OneviewSDK::Switch).to receive(:find_by).and_return([])
      expect(provider.exists?).not_to be
      expect { provider.found }.to raise_error(/No Switch with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    it 'should be able to run through self.instances' do
      test = OneviewSDK::Switch.new(@client, resource['data'])
      allow(OneviewSDK::Switch).to receive(:get_all).and_return([test])
      expect(instance).to be
    end

    it 'should return an error stating that no types match the name given' do
      allow(OneviewSDK::Switch).to receive(:find_by).and_return([])
      allow(OneviewSDK::Switch).to receive(:get_type).with(anything, resource['data']['name']).and_return(nil)
      provider.exists?
      expect { provider.get_type }
        .to raise_error(/\n\n No switch types corresponding to the name #{resource['data']['name']} were found.\n/)
    end
  end

  context 'given the switch get type parameters' do
    it 'should be able to get types' do
      allow(OneviewSDK::Switch).to receive(:get_type).with(anything, resource['data']['name']).and_return(resource['data']['name'])
      provider.exists?
      expect(provider.get_type).to be
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_statistics',
        data:
            {
              'name'                      => '172.18.20.1',
              'port_name'                 => '1.4',
              # 'subport_number'            => 'test'
            }
      )
    end
    it 'should be able to get statistics' do
      resource['data']['uri'] = '/rest/fake'
      data_for_findby = {
        'name'                      => '172.18.20.1',
        'uri'                       => '/rest/fake'
      }
      test = OneviewSDK::Switch.new(@client, resource['data'])
      allow(OneviewSDK::Switch).to receive(:find_by).with(anything, data_for_findby).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new('Fake Get Statistics'))
      provider.exists?
      expect(provider.get_statistics).to be
    end
  end
end
