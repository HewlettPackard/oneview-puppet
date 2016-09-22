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

provider_class = Puppet::Type.type(:oneview_logical_switch).provider(:oneview_logical_switch)
resourcetype = OneviewSDK::LogicalSwitch

describe provider_class, unit: true do
  include_context 'shared context'
  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_switch).new(
        name: 'LS',
        ensure: 'present',
        data:
            {
              'name' => 'LS',
              'logicalSwitchGroupUri' => '/rest/',
              'switches' =>
              [
                {
                  'ip' => '172.18.20.1',
                  'ssh_username' => 'dcs',
                  'ssh_password' => 'dcs',
                  'snmp_port' => '161',
                  'community_string' => 'public'
                },
                {
                  'ip' => '172.18.20.1',
                  'ssh_username' => 'dcs',
                  'ssh_password' => 'dcs',
                  'snmp_port' => '161',
                  'community_string' => 'public'
                }
              ]
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_switch).provider(:oneview_logical_switch)
    end

    it 'return false when the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should be able to find the resource' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      expect(provider.found).to be
    end

    it 'should refresh the logical switch' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      expect_any_instance_of(resourcetype).to receive(:refresh).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.refresh).to be
    end

    it 'should be able to create the resource' do
      data = { 'logicalSwitchCredentials' => [], 'logicalSwitch' => { 'name' => 'LS', 'logicalSwitchGroupUri' => '/rest/',
                                                                      'type' => 'logical-switch', 'switchCredentialConfiguration' => [] } }
      resource['data'].delete('switches')
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/logical-switches', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/logical-switches/fake')
      expect(provider.create).to be
    end
  end

  context 'given the credentials' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_switch).new(
        name: 'LS',
        ensure: 'present',
        data:
            {
              'name' => 'LS',
              'switches' =>
              [
                {
                  'ip' => '172.18.20.1',
                  'ssh_username' => 'dcs',
                  'ssh_password' => 'dcs',
                  'snmp_port' => '161',
                  'community_string' => 'public',
                  'switchUri' => '/rest/'
                }
              ]
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should update the logical switch credentials' do
      request_body = File.read('spec/support/fixtures/unit/provider/logical_switch_update.json')
      resource['data']['uri'] = '/rest/'
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).with(nil, { 'body' => JSON.parse(request_body) }, 200)
        .and_return(uri: '/rest/logical-switches/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('Credentials update')
      expect(provider.update_credentials).to be
    end
  end
end
