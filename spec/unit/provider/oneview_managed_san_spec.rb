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

provider_class = Puppet::Type.type(:oneview_managed_san).provider(:oneview_managed_san)
resourcetype = OneviewSDK::ManagedSAN

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_managed_san).new(
      name: 'managed_san',
      ensure: 'found',
      data:
          {
            'name' => 'SAN1_0'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider oneview_managed_san' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_managed_san).provider(:oneview_managed_san)
    end

    it 'should raise error when server is not found' do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
      provider.exists?
      expect { provider.found }.to raise_error(/No ManagedSAN with the specified data were found on the Oneview Appliance/)
    end
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
            }
      )
    end
    before(:each) do
      resource['data']['uri'] = '/rest/san-managers/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resourcetype).to receive(:get_all).with(anything).and_return([test])
      provider.exists?
    end

    it 'should create/add the managed san' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put)
        .with(resource['data']['uri'], 'body' => { publicAttributes: resource['data']['publicAttributes'] })
        .and_return(uri: '/rest/server-hardware/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put)
        .with(resource['data']['uri'], 'body' => { sanPolicy: resource['data']['sanPolicy'] })
        .and_return(uri: '/rest/server-hardware/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/server-hardware/fake')
      expect(provider.create).to be
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to run through get_zoning_report' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with(resource['data']['uri'] + '/issues', 'body' => {}).and_return(uri: '/rest/san-managers/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('Get zoning report Json')
      expect(provider.get_zoning_report).to be
    end

    it 'should be able to run through set_refresh_state' do
      resource['data']['refreshState'] = 'RefreshPending'
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put)
        .with(resource['data']['uri'], 'body' => { refreshState: resource['data']['refreshState'] })
        .and_return(uri: '/rest/san-managers/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('Refresh state set')
      expect(provider.set_refresh_state).to be
    end
  end

  context 'given the minimum parameters after server creation' do
    before(:each) do
      resource['data']['uri'] = '/rest/san-managers/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end
    it 'should be able to run through found' do
      expect(provider.found).to be
    end

    it 'should be able to run through get_endpoints' do
      allow_any_instance_of(resourcetype).to receive(:get_endpoints).and_return(['Get Endpoints Json'])
      expect(provider.get_endpoints).to be
    end

    it 'should delete the managed san' do
      expect { provider.destroy }.to raise_error(/Absent is not a valid ensurable for this resource/)
    end
  end
end
