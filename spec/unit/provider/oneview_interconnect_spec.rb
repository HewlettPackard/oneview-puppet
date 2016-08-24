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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_interconnect).provider(:oneview_interconnect)
resourcetype = OneviewSDK::Interconnect

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the min parameters' do
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
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_interconnect).provider(:oneview_interconnect)
    end

    it 'should be able to get the name servers' do
      allow_any_instance_of(resourcetype).to receive(:name_servers).and_return('Test')
      expect(provider.get_name_servers).to be
    end

    it 'should be able to get the statistics' do
      allow_any_instance_of(resourcetype).to receive(:statistics).and_return('Test')
      expect(provider.get_statistics).to be
    end

    it 'should be able to reset the port protection' do
      allow_any_instance_of(resourcetype).to receive(:reset_port_protection).and_return('Test')
      expect(provider.reset_port_protection).to be
    end

    it 'should be able to update the ports' do
      allow_any_instance_of(resourcetype).to receive(:update_port).and_return('Test')
      expect(provider.update_ports).to be
    end
  end
end
