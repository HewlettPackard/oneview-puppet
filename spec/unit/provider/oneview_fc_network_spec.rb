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

provider_class = Puppet::Type.type(:oneview_fc_network).provider(:c7000)

describe provider_class, unit: true do
  include_context 'shared context'
  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fc_network).new(
        name: 'fc',
        ensure: 'present',
        data:
            {
              'name'                    => 'OneViewSDK Test FC Network',
              'connectionTemplateUri'   => nil,
              'autoLoginRedistribution' => true,
              'fabricType'              => 'FabricAttach',
              'type' => 'fc-networkV2',
              'linkStabilityTime' => 30
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider oneview_fc_network' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fc_network).provider(:c7000)
    end

    it 'if nothing is found should return false' do
      expect(OneviewSDK::FCNetwork).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return true when resource exists' do
      test = [OneviewSDK::FCNetwork.new(@client, resource['data'])]
      expect(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, resource['data']).and_return(test)
      expect(provider.exists?).to eq(true)
    end

    it 'runs through the create method' do
      allow(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, resource['data']).and_return([])
      allow(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([])
      test = OneviewSDK::FCNetwork.new(@client, resource['data'])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/fc-networks', { 'body' => resource['data'] }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/fc-networks/100')
      provider.exists?
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::FCNetwork.new(@client, resource['data'])
      allow(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      test = OneviewSDK::FCNetwork.new(@client, resource['data'])
      allow(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, {}).and_return([test])
      expect(instance).to be
    end

    it 'finds the resource' do
      test = OneviewSDK::FCNetwork.new(@client, resource['data'])
      allow(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect(provider.found).to be
    end
  end
end
