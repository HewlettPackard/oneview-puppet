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

provider_class = Puppet::Type.type(:oneview_server_profile).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:ServerProfile, api_version, :C7000)
fake_json_response = File.read('spec/support/fixtures/unit/provider/server_profile.json')

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_server_profile).new(
      name: 'Server Profile',
      ensure: 'present',
      data:
          {
            'name' => 'Profile',
            'description' => 'description',
            'serverHardwareUri' => '/rest/server-hardware/37333036-3831-584D-5131-303030323037'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  before(:each) do
    allow(resource_type).to receive(:find_by).and_return([test])
    allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(resource_type).to receive(:like?).and_return(true)
    provider.exists?
  end

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile).provider(:c7000)
    end

    it 'should raise error when server is not found' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect { provider.found }.to raise_error(/No ServerProfile with the specified data were found on the Oneview Appliance/)
    end

    it 'should create when resource does not exist' do
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(false)
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should not create when resource is compliant' do
      expect(provider.exists?).to eq(true)
      expect(resource_type).not_to receive(:create)
      expect(provider.create).to be
    end

    it 'should update when resource is not compliant' do
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(resource_type).to receive(:like?).and_return(false)
      expect_any_instance_of(resource_type).to receive(:update).and_return(true)
      expect_any_instance_of(resource_type).not_to receive(:create)
      expect(provider.create).to be
    end

    it 'should be able to perform the patch update' do
      allow_any_instance_of(resource_type).to receive(:update_from_template).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.update_from_template).to be
    end

    it 'should be able to get available targets' do
      allow(resource_type).to receive(:get_available_targets).with(anything, nil).and_return(fake_json_response)
      expect(provider.get_available_targets).to be
    end

    it 'should be able to get the compliance preview' do
      allow_any_instance_of(resource_type).to receive(:get_compliance_preview).and_return(fake_json_response)
      expect(provider.get_compliance_preview).to be
    end

    it 'should be able to get available networks' do
      allow_any_instance_of(resource_type).to receive(:get_available_networks).and_return(fake_json_response)
      expect(provider.get_available_networks).to be
    end

    it 'should be able to get the transformation' do
      allow_any_instance_of(resource_type).to receive(:get_transformation).and_return(fake_json_response)
      expect(provider.get_transformation).to be
    end

    it 'should be able to get messages' do
      allow_any_instance_of(resource_type).to receive(:get_messages).and_return(fake_json_response)
      expect(provider.get_messages).to be
    end

    it 'should be able to get available servers' do
      allow(resource_type).to receive(:get_available_servers).and_return(fake_json_response)
      expect(provider.get_available_servers).to be
    end

    it 'should be able to get profile ports' do
      allow(resource_type).to receive(:get_profile_ports).and_return(fake_json_response)
      expect(provider.get_profile_ports).to be
    end

    it 'should delete the server profile' do
      expect_any_instance_of(resource_type).to receive(:delete).and_return(true)
      expect(provider.destroy).to be
    end

    it 'should raise an error for methods that are not available' do
      expect { provider.get_sas_logical_jbods }.to raise_error(/This ensure method is not available for C7000./)
      expect { provider.get_sas_logical_jbod_drives }.to raise_error(/This ensure method is not available for C7000./)
      expect { provider.get_sas_logical_jbod_attachments }.to raise_error(/This ensure method is not available for C7000./)
    end
  end

  context 'given the available storage systems query parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile).new(
        name: 'Server Profile',
        ensure: 'get_available_networks',
        data:
            {
              'query_parameters' => {
                'enclosureGroupUri'     => '/rest/fake',
                'storageSystemId'       => '/rest/fake',
                'serverHardwareTypeUri' => '/rest/fake'
              }
            },
        provider: 'c7000'
      )
    end

    it 'should successfully get an available storage system' do
      allow(resource_type).to receive(:get_available_storage_system).and_return(true)
      expect(provider.get_available_storage_system).to be
    end

    it 'should successfully get_available_storage_systems' do
      allow(resource_type).to receive(:get_available_storage_systems).and_return(true)
      expect(provider.get_available_storage_systems).to be
    end

    it 'should successfully get_available_networks' do
      allow(resource_type).to receive(:get_available_networks).and_return(true)
      provider.exists?
      expect(provider.get_available_networks).to be
    end
  end
end
