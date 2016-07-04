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

provider_class = Puppet::Type.type(:oneview_enclosure).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_enclosure).new(
      name: 'Enclosure',
      ensure: 'present',
        data:
          {
            'name'              => 'Puppet_Test_Enclosure',
            'hostname'          => '172.18.1.13',
            'username'          => 'dcs',
            'password'          => 'dcs',
            'enclosureGroupUri' => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
            'licensingIntent'   => 'OneView'
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure).provider(:ruby)
  end

  # Negative testing set_refresh_state
  context 'given the minimum parameters' do
    let(:resource) {
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
          data:
            {
              'name'              => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
              'licensingIntent'   => 'OneView',
              'refreshState'      => 'RefreshPending'
            },
      )
    }

    it 'should not be able to set a refresh state on the enclosure' do
      expect(provider.set_refresh_state).not_to be
    end
  end

  # Negative testing retrieved_utilization
  context 'given the minimum parameters' do
    let(:resource) {
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
          data:
            {
              'name'                   => 'Puppet_Test_Enclosure',
              'enclosureGroupUri'      => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
              'licensingIntent'        => 'OneView',
              'utilization_parameters' => {
                'view' => 'day'
                },
            },
      )
    }
      it 'should not be able to retrieve utilization data from the enclosure' do
        expect(provider.retrieved_utilization).not_to be
      end
    end

  context 'given the minimum parameters' do

    it 'exists? should not find the enclosure' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the enclosure was not found' do
      expect(provider.found).not_to be
    end

    it 'should not be able to get configuration from the enclosure' do
      expect(provider.configured).not_to be
    end

    it 'should not be able to retrieve environmental configuration from the enclosure' do
      expect(provider.retrieved_environmental_configuration).not_to be
    end

    it 'should not be able to retrieve the script from the enclosure' do
      expect(provider.script_retrieved).not_to be
    end

    it 'should create the new enclosure' do
      expect(provider.create).to be
    end

    it 'should find that the enclosure exists' do
      expect(provider.exists?).to be
    end

  end

  context 'given the minimum parameters' do
    let(:resource) {
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
          data:
            {
              'name'              => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
              'licensingIntent'   => 'OneView',
              'refreshState'      => 'RefreshPending'
            },
      )
    }

    it 'should be able to set a refresh state on the enclosure' do
      expect(provider.set_refresh_state).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) {
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
          data:
            {
              'name'                   => 'Puppet_Test_Enclosure',
              'enclosureGroupUri'      => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
              'licensingIntent'        => 'OneView',
              'utilization_parameters' => {
                'view' => 'day'
                },
            },
      )
    }
      it 'should be able to retrieve utilization data from the enclosure' do
        expect(provider.retrieved_utilization).to be
      end
    end

  context 'given the minimum parameters' do
    let(:resource) {
      Puppet::Type.type(:oneview_enclosure).new(
        name: 'Enclosure',
        ensure: 'present',
          data:
            {
              'name'              => 'Puppet_Test_Enclosure',
              'enclosureGroupUri' => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
              'licensingIntent'   => 'OneView'
            },
      )
    }
    it 'should return that the enclosure was found' do
      expect(provider.found).to be
    end

    it 'should destroy the enclosure' do
      expect(provider.destroy).to be
    end

  end

end
