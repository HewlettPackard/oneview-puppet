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

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_server_profile).new(
      name: 'Server Profile',
      ensure: 'present',
      data:
          {
            'name'              => 'Test Server Profile',
            'serverHardwareUri' => '172.18.6.6'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile).provider(:c7000)
    end

    it 'should be able to create the server profile' do
      expect(provider.create).to be
    end

    it 'should be able to find the server profile with no filters' do
      resource['data'] = {}
      expect(provider.found).to be
    end

    it 'should be able to get_available_targets' do
      expect(provider.get_available_targets).to be
    end

    it 'should be able to get_available_networks' do
      expect(provider.get_available_networks).to be
    end

    it 'should be able to get_available_servers' do
      expect(provider.get_available_servers).to be
    end

    it 'should be able to get_available_storage_systems' do
      expect(provider.get_available_storage_systems).to be
    end

    it 'should be able to get_available_storage_system' do
      expect(provider.get_available_storage_system).to be
    end

    it 'should be able to get_profile_ports' do
      expect(provider.get_profile_ports).to be
    end

    it 'should be able to get_compliance_preview' do
      expect(provider.get_compliance_preview).to be
    end

    it 'should be able to get_messages' do
      expect(provider.get_messages).to be
    end

    it 'should be able to get_transformation' do
      expect(provider.get_transformation).to be
    end

    it 'should be able to update_from_template' do
      expect(provider.update_from_template).to be
    end

    it 'should raise errors for unavailable methods' do
      expect { provider.get_sas_logical_jbods }.to raise_error(/This ensure method is not available for C7000./)
      expect { provider.get_sas_logical_jbod_drives }.to raise_error(/This ensure method is not available for C7000./)
      expect { provider.get_sas_logical_jbod_attachments }.to raise_error(/This ensure method is not available for C7000./)
    end

    it 'should be able to update the server profile' do
      resource['data'] = { 'name' => 'Test Server Profile', 'new_name' => 'Edited SP' }
      expect(provider.create).to be
    end

    it 'should be able to delete the server profile' do
      resource['data'] = { 'name' => 'Edited SP' }
      expect(provider.destroy).to be
    end
  end
end
