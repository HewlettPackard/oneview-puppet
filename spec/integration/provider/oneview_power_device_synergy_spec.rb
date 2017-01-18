################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_power_device).provider(:synergy)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_power_device).new(
      name: 'Power Device',
      ensure: 'discover',
      data:
          {
            'hostname' => '172.18.8.11',
            'username' => 'dcs',
            'password' => 'dcs'
          },
      provider: 'synergy'

    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_power_device).provider(:synergy)
    end

    it 'should be able to discover the power devices' do
      expect(provider.discover).to be
    end
  end

  describe provider_class do
    let(:resource) do
      Puppet::Type.type(:oneview_power_device).new(
        name: 'Power Device',
        ensure: 'found',
        data:
            {
              'name' => '172.18.8.11, PDU 1'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      provider.exists?
    end

    context 'given the minimum parameters after resource creation' do
      it 'should be able to find the power devices' do
        expect(provider.found).to be
      end
    end
  end

  describe provider_class do
    let(:resource) do
      Puppet::Type.type(:oneview_power_device).new(
        name: 'Power Device',
        ensure: 'set_refresh_state',
        data:
            {
              'name' => '172.18.8.11, PDU 1',
              'refreshOptions' =>
              {
                'refreshState' => 'RefreshPending',
                'username'     => 'dcs',
                'password'     => 'dcs'
              }
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      provider.exists?
    end

    context 'given the minimum parameters after resource creation' do
      it 'should be able to set the refresh state' do
        expect(provider.set_refresh_state).to be
      end
    end
  end

  describe provider_class do
    let(:resource) do
      Puppet::Type.type(:oneview_power_device).new(
        name: 'Power Device',
        ensure: 'present',
        data:
            {
              'name' => 'New Power Device',
              'ratedCapacity' => 40
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      provider.exists?
    end

    context 'given the minimum' do
      it 'should be able to add a power device' do
        expect(provider.create).to be
      end
    end
  end

  describe provider_class do
    let(:resource) do
      Puppet::Type.type(:oneview_power_device).new(
        name: 'Power Device',
        ensure: 'absent',
        data:
            {
              'name' => 'New Power Device'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      provider.exists?
    end

    context 'given the minimum parameters after resource creation' do
      it 'should be able to find the power devices' do
        expect(provider.found).to be
      end

      it 'should be able to destroy the resource' do
        expect(provider.destroy).to be
      end
    end
  end
end
