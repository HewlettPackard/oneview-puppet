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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

# NOTE: This test REQUIRES an enclosure group to be created and listed either on the enclosure_group
# var on the json containing the login info, or down bellow directly in the var.

provider_class = Puppet::Type.type(:oneview_enclosure).provider(:c7000)
enclosure_ip = login[:enclosure_ip] || '172.18.1.13'
enclosure_username = login[:enclosure_username] || 'dcs'
enclosure_password = login[:enclosure_password] || 'dcs'
enclosure_group = login[:enclosure_group] || 'Puppet Enc Group Test'

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_enclosure).new(
      name: 'Enclosure',
      ensure: 'present',
      data:
          {
            'name'              => 'Puppet_Test_Enclosure',
            'hostname'          => enclosure_ip,
            'username'          => enclosure_username,
            'password'          => enclosure_password,
            'enclosureGroupUri' => enclosure_group,
            'licensingIntent'   => 'OneView'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider oneview_enclosure' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure).provider(:c7000)
  end

  # Negative testing set_refresh_state
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'name'              => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => enclosure_group,
              'licensingIntent'   => 'OneView',
              'refreshState'      => 'RefreshPending'
            }
      )
    end

    it 'should not be able to set a refresh state on the enclosure' do
      provider.exists?
      expect { provider.set_refresh_state }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end
  end

  # Negative testing retrieved_utilization
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'name' => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => enclosure_group,
              'licensingIntent'        => 'OneView',
              'utilization_parameters' => {
                'view' => 'day'
              }
            }
      )
    end

    it 'should not be able to get utilization data from the enclosure' do
      provider.exists?
      expect { provider.get_utilization }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end
  end

  # Negative testing create certificate request
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'create_csr',
        data:
            {
              'uri'                 => '/rest/enclosures/09SGH104X6J1',
              'type'                => 'CertificateDtoV2',
              'organization'        => 'Acme Corp.',
              'organizationalUnit'  => 'IT',
              'locality'            => 'Townburgh',
              'state'               => 'Mississippi',
              'country'             => 'US',
              'email'               => 'admin@example.com',
              'commonName'          => 'fe80::2:0:9:1%eth2',
              'bay_number'          => '1'
            }
      )
    end

    it 'should not be able to create the certificate request' do
      provider.exists?
      expect { provider.create_csr }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end
  end

  # Negative testing get_csr
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'get_csr',
        data:
            {
              'uri'           => '/rest/enclosures/09SGH104X6J1',
              'bay_number'    => '1'
            }
      )
    end

    it 'should not be able to get the certificate request' do
      provider.exists?
      expect { provider.get_csr }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end
  end

  # Negative testing import certificate
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'import_csr',
        data:
            {
              'uri'           => '/rest/enclosures/09SGH104X6J1',
              'bay_number'    => '1'
            }
      )
    end

    it 'should not be able to import certificate request' do
      provider.exists?
      expect { provider.import_csr }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end
  end

  context 'given the minimum parameters' do
    before(:each) do
      provider.exists?
    end

    it 'exists? should not find the enclosure' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the enclosure was not found' do
      expect { provider.found }.to raise_error(
        /No Enclosure with the specified data were found on the Oneview Appliance/
      )
    end

    it 'should not be able to get configuration from the enclosure' do
      expect { provider.set_configuration }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end

    it 'should not be able to retrieve environmental configuration from the enclosure' do
      expect { provider.get_environmental_configuration }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end

    it 'should not be able to retrieve the script from the enclosure' do
      expect { provider.get_script }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end

    it 'should create the new enclosure' do
      expect(provider.create).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'name'              => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => enclosure_group,
              'licensingIntent'   => 'OneView',
              'refreshState'      => 'RefreshPending'
            }
      )
    end

    it 'should be able to set a refresh state on the enclosure' do
      provider.exists?
      expect(provider.set_refresh_state).to be
    end
  end

  context 'given the utilization parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'name' => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => enclosure_group,
              # 'enclosureGroupUri'      => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
              'licensingIntent'        => 'OneView',
              'utilization_parameters' => {
                'view' => 'day'
              }
            }
      )
    end
    it 'should be able to get utilization data from the enclosure' do
      provider.exists?
      expect(provider.get_utilization).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'create_csr',
        data:
            {
              'uri'                 => '/rest/enclosures/09SGH104X6J1',
              'type'                => 'CertificateDtoV2',
              'organization'        => 'Acme Corp.',
              'organizationalUnit'  => 'IT',
              'locality'            => 'Townburgh',
              'state'               => 'Mississippi',
              'country'             => 'US',
              'email'               => 'admin@example.com',
              'commonName'          => 'fe80::2:0:9:1%eth2',
              'bay_number'          => '1'
            }
      )
    end
    it 'should be ablt to create a certificate request' do
      provider.exists?
      expect(provider.create_csr).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'get_csr',
        data:
            {
              'uri'           => '/rest/enclosures/09SGH104X6J1',
              'bay_number'    => '1'
            }
      )
    end
    it 'should be able to get the certificate request' do
      provider.exists?
      expect(provider.get_csr).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'import_csr',
        data:
            {
              'uri'           => '/rest/enclosures/09SGH104X6J1',
              'bay_number'    => '1'
            }
      )
    end
    it 'should be able to import the certifiacte request' do
      provider.exists?
      expect(provider.import_csr).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'name'              => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => enclosure_group,
              'licensingIntent'   => 'OneView'
            }
      )
    end
    before(:each) do
      provider.exists?
    end

    it 'should return that the enclosure was found' do
      expect(provider.found).to be
    end

    # it 'should destroy the enclosure' do
    #   expect(provider.destroy).to be
    # end
  end
end
