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
require_relative '../../../lib/puppet/provider/login'

provider_class = Puppet::Type.type(:oneview_managed_san).provider(:synergy)
managed_san_name = login[:managed_san_name] || 'SAN1_0'

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_managed_san).new(
      name: 'managed_san',
      ensure: 'found',
      data:
          {
            'name' => managed_san_name
          },
      provider: 'synergy'
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_managed_san).provider(:synergy)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_managed_san).new(
        name: 'managed_san',
        ensure: 'present',
        data:
            {
              'name' => managed_san_name,
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
      expect(provider.create).to be
    end
    it 'should be able to run through self.instances' do
      expect(instance).to be
    end
  end

  context 'given the minimum parameters after server creation' do
    it 'should be able to run through found' do
      expect(provider.found).to be
    end

    it 'should be able to run through get_zoning_report' do
      expect(provider.get_zoning_report).to be
    end

    it 'should be able to run through get_endpoints' do
      expect(provider.get_endpoints).to be
    end

    it 'should be able to run through set_refresh_state' do
      resource['data']['refreshState'] = 'RefreshPending'
      expect(provider.set_refresh_state).to be
    end

    it 'should delete the managed san' do
      expect { provider.destroy }.to raise_error(/Absent is not a valid ensurable for this resource/)
    end
  end
end
