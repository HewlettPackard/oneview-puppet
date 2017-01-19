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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_enclosure).provider(:oneview_enclosure)
resourcetype = OneviewSDK::Enclosure

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_enclosure).new(
      name: 'Enclosure',
      ensure: 'present',
      data:
          {
            'name' => 'Puppet_Test_Enclosure',
            'hostname' => '172.18.1.13',
            'username' => 'dcs',
            'password' => 'dcs',
            'enclosureGroupUri' => '/rest/',
            'licensingIntent' => 'OneView',
            'refreshState' => 'RefreshPending',
            'utilization_parameters' =>
            {
              'view' => 'day'
            }
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure).provider(:c7000)
    end

    it 'should be able to run through self.instances' do
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(instance).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to get the environmental configuration' do
      allow_any_instance_of(resourcetype).to receive(:environmental_configuration).and_return('Test')
      expect(provider.get_environmental_configuration).to be
    end

    it 'should be able to set the configuration' do
      allow_any_instance_of(resourcetype).to receive(:configuration).and_return('Test')
      expect(provider.set_configuration).to be
    end

    it 'should be able to set the refresh state' do
      allow_any_instance_of(resourcetype).to receive(:set_refresh_state).and_return('Test')
      expect(provider.set_refresh_state).to be
    end

    it 'should be able to set the refresh state' do
      allow_any_instance_of(resourcetype).to receive(:utilization).with(resource['data']['utilization_parameters']).and_return('Test')
      expect(provider.get_utilization).to be
    end

    it 'should be able to set the refresh state' do
      allow_any_instance_of(resourcetype).to receive(:script).and_return('Test')
      expect(provider.get_script).to be
    end

    it 'should be able to set the refresh state' do
      expect { provider.get_single_sign_on }.to raise_error(RuntimeError)
    end

    it 'should be able to work specifying a name instead of an uri' do
      resource['data']['enclosureGroupUri'] = 'Test'
      test = resourcetype.new(@client, resource['data'])
      allow(OneviewSDK::EnclosureGroup).to receive(:find_by).with(anything, name: resource['data']['enclosureGroupUri']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end

    context 'given the creation parameters' do
      let(:resource) do
        Puppet::Type.type(:oneview_enclosure).new(
          name: 'Enclosure',
          ensure: 'present',
          data:
              {
                'name' => 'Puppet_Test_Enclosure',
                'hostname' => '172.18.1.13',
                'username' => 'dcs',
                'password' => 'dcs',
                'enclosureGroupUri' => '/rest/',
                'licensingIntent' => 'OneView'
              }
        )
      end

      it 'creates the resource' do
        test = resourcetype.new(@client, resource['data'])
        allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
        allow(resourcetype).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([])
        allow(resourcetype).to receive(:find_by).with(anything, uri: '/rest/fake').and_return([test])
        allow_any_instance_of(resourcetype).to receive(:add).and_return(test)
        provider.exists?
        expect(provider.create).to be
      end

      it 'patches the resource' do
        unique_id = { 'uri' => '/rest/fake', 'name' => 'Puppet_Test_Enclosure' }
        resource['data']['uri'] = '/rest/fake'
        resource['data']['op'] = 'fake_op'
        resource['data']['path'] = 'fake_path'
        resource['data']['value'] = 'fake_value'
        patch_data = { op: 'fake_op', path: 'fake_path', value: 'fake_value' }
        test = resourcetype.new(@client, resource['data'])
        allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
        allow(resourcetype).to receive(:find_by).with(anything, unique_id).and_return([test])
        expect_any_instance_of(OneviewSDK::Client).to receive(:rest_patch)
          .with(resource['data']['uri'], { 'body' => [patch_data] }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
        provider.exists?
        expect(provider.create).to be
      end
    end
  end
end
