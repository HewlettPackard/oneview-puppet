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

provider_class = Puppet::Type.type(:oneview_enclosure).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:Enclosure, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

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
          },
      provider: 'c7000'
    )
  end

  context 'given the min parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure).provider(:c7000)
    end

    it 'should be able to get the environmental configuration' do
      allow_any_instance_of(resource_type).to receive(:environmental_configuration).and_return('Test')
      expect(provider.get_environmental_configuration).to be
    end

    it 'should be able to set the configuration' do
      allow_any_instance_of(resource_type).to receive(:configuration).and_return('Test')
      expect(provider.set_configuration).to be
    end

    it 'should be able to set the refresh state' do
      allow_any_instance_of(resource_type).to receive(:set_refresh_state).and_return('Test')
      expect(provider.set_refresh_state).to be
    end

    it 'should be able to retrieve utilization statistics' do
      allow_any_instance_of(resource_type).to receive(:utilization).with(resource['data']['utilization_parameters']).and_return('Test')
      expect(provider.get_utilization).to be
    end

    it 'should be able to get the script from the enclosure' do
      allow_any_instance_of(resource_type).to receive(:script).and_return('Test')
      expect(provider.get_script).to be
    end

    it '#get_single_sign_on should raise an error' do
      expect { provider.get_single_sign_on }.to raise_error(RuntimeError)
    end

    it '#set_environmental_configuration should raise an error' do
      expect { provider.set_environmental_configuration }.to raise_error(RuntimeError)
    end

    it 'should be able to work specifying a name instead of an uri' do
      resource['data']['enclosureGroupUri'] = 'Test'
      test = resource_type.new(@client, resource['data'])
      allow(OneviewSDK::EnclosureGroup).to receive(:find_by).with(anything, name: resource['data']['enclosureGroupUri']).and_return([test])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resource_type).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([test])
      expect_any_instance_of(resource_type).to receive(:remove).and_return({})
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
              },
          provider: 'c7000'
        )
      end

      it 'creates the resource' do
        allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([])
        allow(resource_type).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([])
        allow(resource_type).to receive(:find_by).with(anything, uri: '/rest/fake').and_return([test])
        allow_any_instance_of(resource_type).to receive(:add).and_return(test)
        allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
        provider.exists?
        expect(provider.create).to be
      end

      it 'patches the resource' do
        resource['data']['uri'] = '/rest/fake'
        resource['data']['op'] = 'fake_op'
        resource['data']['path'] = 'fake_path'
        resource['data']['value'] = 'fake_value'
        test = resource_type.new(@client, resource['data'])
        allow(resource_type).to receive(:find_by).and_return([test])
        expect_any_instance_of(resource_type).to receive(:patch).and_return(true)
        provider.exists?
        expect(provider.create).to be
      end
    end
  end
end
