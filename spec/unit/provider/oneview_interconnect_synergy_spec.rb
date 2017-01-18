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
require_relative '../../shared_context'
require_relative '../../support/fake_response'

provider_class = Puppet::Type.type(:oneview_interconnect).provider(:synergy)
resourcetype = OneviewSDK::API300::Synergy::Interconnect
describe provider_class, unit: true do
  include_context 'shared context'
  let(:resource) do
    Puppet::Type.type(:oneview_interconnect).new(
      name: 'Interconnect',
      ensure: 'present',
      data:
          {
            'name' => 'Encl2, interconnect 1',
            'ports' =>
            [
              {
                'portName' => 'x1',
                'enabled' => true
              }
            ]
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_interconnect).provider(:synergy)
    end

    it 'should be able to get the name servers' do
      allow_any_instance_of(resourcetype).to receive(:name_servers).and_return('Test')
      expect(provider.get_name_servers).to be
    end

    it 'should be able to get the statistics' do
      allow_any_instance_of(resourcetype).to receive(:statistics).and_return('Test')
      expect(provider.get_statistics).to be
    end

    it 'should be able to get the statistics' do
      resource['data']['statistics'] = {}
      resource['data']['statistics']['portName'] = 'portname'
      resource['data']['statistics']['subportNumber'] = 'subportname'
      allow_any_instance_of(resourcetype).to receive(:statistics).and_return('Test')
      provider.exists?
      expect(provider.get_statistics).to be
    end

    it 'should be able to reset the port protection' do
      allow_any_instance_of(resourcetype).to receive(:reset_port_protection).and_return('Test')
      expect(provider.reset_port_protection).to be
    end

    it 'should be able to update the ports' do
      allow(resourcetype).to receive(:update_port).and_return('Test')
      expect(provider.update_ports).to be
    end

    it 'should be able to get the link topologies' do
      allow(resourcetype).to receive(:get_link_topologies).and_return(['Test'])
      expect(provider.get_link_topologies).to be
    end

    it 'should raise an error when trying to create a resource' do
      expect { provider.create }.to raise_error(/This resource relies on others to be created/)
    end
  end
  context 'given the min parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([])
      provider.exists?
    end
    let(:resource) do
      Puppet::Type.type(:oneview_interconnect).new(
        name: 'Interconnect',
        ensure: 'get_link_topologies',
        provider: 'synergy'
      )
    end

    it 'should be able to get all the link topologies' do
      allow(resourcetype).to receive(:get_link_topologies).and_return(['Test'])
      expect(provider.get_link_topologies).to be
    end

    it 'should be able to get all the link topologies' do
      allow(resourcetype).to receive(:get_types).and_return(['Test'])
      expect(provider.get_types).to be
    end
  end
end
