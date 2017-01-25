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

provider_class = Puppet::Type.type(:oneview_switch).provider(:oneview_switch)
api_version = login[:api_version] || 200
resource_name = 'Switch'
resourcetype = Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_switch).new(
      name: 'Switch',
      ensure: 'present',
      data:
          {
            'name' => '172.18.20.1'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'raises errors for most methods' do
    expect { provider.create }.to raise_error(/Method unavailable for Synergy/)
    expect { provider.destroy }.to raise_error(/Method unavailable for Synergy/)
    expect { provider.get_statistics }.to raise_error(/Method unavailable for Synergy/)
    expect { provider.get_environmental_configuration }.to raise_error(/Method unavailable for Synergy/)
    expect { provider.set_scope_uris }.to raise_error(/Method unavailable for Synergy/)
  end

  context '#get_type given a name' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_type',
        data:
            {
              'name' => '172.18.20.1'
            },
        provider: 'synergy'
      )
    end
    it 'should be able to get type for a specific switch' do
      allow(resourcetype).to receive(:get_type).and_return(['fake_type'])
      provider.exists?
      expect(provider.get_type).to be
    end
  end

  context 'given the switch get type parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_switch).new(
        name: 'Switch',
        ensure: 'get_type',
        data: {},
        provider: 'synergy'
      )
    end
    it 'should be able to get types' do
      allow(resourcetype).to receive(:get_types).and_return(['fake_type'])
      provider.exists?
      expect(provider.get_type).to be
    end
  end
end
