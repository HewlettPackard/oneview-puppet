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

provider_class = Puppet::Type.type(:oneview_switch).provider(:synergy)

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_switch).new(
      name: 'Switch',
      ensure: 'get_type',
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given no parameters for get types' do
    before(:each) do
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_switch).provider(:synergy)
    end

    it 'should be able to get types' do
      provider.exists?
      expect(provider.get_type).to be
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_type',
        data:
            {
              'name' => 'Cisco Nexus 50xx'
            },
        provider: 'synergy'
      )
    end
    it 'should be able to get a specific type' do
      provider.exists?
      expect(provider.get_type).to be
    end
  end
end
