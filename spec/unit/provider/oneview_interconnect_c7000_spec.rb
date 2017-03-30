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

provider_class = Puppet::Type.type(:oneview_interconnect).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:Interconnect, api_version, :C7000)

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
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_interconnect).provider(:c7000)
    end

    it 'should be able to find the interconnects' do
      allow(resource_type).to receive(:find_by).and_return([test])
      expect(provider.found).to be
    end

    it 'should be able to get the name servers' do
      allow_any_instance_of(resource_type).to receive(:name_servers).and_return('Test')
      expect(provider.get_name_servers).to be
    end

    it 'should be able to get the types filtered by a name' do
      allow(resource_type).to receive(:get_type).and_return('Test')
      expect(provider.get_types).to be
    end

    it 'should be able to get the statistics' do
      allow_any_instance_of(resource_type).to receive(:statistics).and_return('Test')
      expect(provider.get_statistics).to be
    end

    it 'should be able to reset the port protection' do
      allow_any_instance_of(resource_type).to receive(:reset_port_protection).and_return('Test')
      expect(provider.reset_port_protection).to be
    end

    it 'should be able to update the ports' do
      allow_any_instance_of(resource_type).to receive(:update_port).and_return('Test')
      expect(provider.update_ports).to be
    end

    it 'should raise an error when trying to destroy a resource' do
      expect { provider.destroy }.to raise_error(/This resource relies on others to be destroyed/)
    end

    it 'should raise an error when trying to run get_link_topologies' do
      expect { provider.get_link_topologies }.to raise_error(/This ensure method is only supported by the Synergy resource variant/)
    end
  end
end
