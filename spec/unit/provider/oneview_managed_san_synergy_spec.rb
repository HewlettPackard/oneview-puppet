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

provider_class = Puppet::Type.type(:oneview_managed_san).provider(:synergy)
api_version = login[:api_version] || 200
resource_name = 'ManagedSAN'
resourcetype = Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_managed_san).new(
      name: 'managed_san',
      ensure: 'found',
      data:
          {
            'name' => 'SAN1_0'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  before(:each) do
    allow(resourcetype).to receive(:find_by).and_return([test])
    allow(resourcetype).to receive(:get_all).and_return([test])
    provider.exists?
  end

  it 'should be an instance of the provider synergy' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_managed_san).provider(:synergy)
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_managed_san).new(
        name: 'managed_san',
        ensure: 'present',
        data:
            {
              'name' => 'SAN1_0',
              'publicAttributes' => {
                'name' => 'MetaSan',
                'value' => 'Neon SAN',
                'valueType' => 'String',
                'valueFormat' => 'None'
              },
              'sanPolicy' => {
                'zoningPolicy' => 'SingleInitiatorAllTargets',
                'zoneNameFormat' => '{hostName}_{initiatorWwn}',
                'enableAliasing' => true,
                'initiatorNameFormat' => '{hostName}_{initiatorWwn}',
                'targetNameFormat' => '{storageSystemName}_{targetName}',
                'targetGroupNameFormat' => '{storageSystemName}_{targetGroupName}'
              }
            },
        provider: 'synergy'
      )
    end
    it 'should create/add the managed san' do
      allow_any_instance_of(resourcetype).to receive(:set_public_attributes).and_return(test)
      allow_any_instance_of(resourcetype).to receive(:set_san_policy).and_return(test)
      expect(provider.create).to be
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to run through get_zoning_report' do
      allow_any_instance_of(resourcetype).to receive(:get_zoning_report).and_return(true)
      expect(provider.get_zoning_report).to be
    end

    it 'should be able to run through set_refresh_state' do
      resource['data']['refreshState'] = 'RefreshPending'
      allow_any_instance_of(resourcetype).to receive(:set_refresh_state).and_return(true)
      expect(provider.set_refresh_state).to be
    end
  end

  context 'given the minimum parameters after server creation' do
    it 'should be able to run through found' do
      expect(provider.found).to be
    end

    it 'should be able to run through get_endpoints' do
      allow_any_instance_of(resourcetype).to receive(:get_endpoints).and_return(true)
      expect(provider.get_endpoints).to be
    end

    it 'should delete the managed san' do
      expect { provider.destroy }.to raise_error(/Absent is not a valid ensurable for this resource/)
    end
  end
end
