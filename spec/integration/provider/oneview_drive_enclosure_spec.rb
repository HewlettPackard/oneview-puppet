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

provider_class = Puppet::Type.type(:oneview_drive_enclosure).provider(:synergy)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_drive_enclosure).new(
      name: 'Test LIG',
      ensure: 'present',
      data:
      {
        'name'  => 'Encl1, bay 1',
        'patch' =>
        {
          'op'    => 'replace',
          'path'  => '/hardResetState',
          'value' => 'Reset'
        }
      },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider synergy' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_drive_enclosure).provider(:synergy)
  end

  context 'given the minimum parameters' do
    it 'should raise an error on the create and destroy operations' do
      expect { provider.create }.to raise_error(/This resource cannot be created directly./)
      expect { provider.destroy }.to raise_error(/This resource cannot be destroyed directly./)
    end

    it 'should be able to find the sas logical interconnect group' do
      expect(provider.found).to be
    end
  end

  context 'given the refreshState field' do
    let(:resource) do
      Puppet::Type.type(:oneview_drive_enclosure).new(
        name: 'Test LIG',
        ensure: 'present',
        data:
        {
          'name'         => 'Encl1, bay 1',
          'refreshState' => 'RefreshPending'
        },
        provider: 'synergy'
      )
    end
    it 'should be able to refresh the drive enclosure' do
      expect(provider.set_refresh_state).to be
    end
  end
end
