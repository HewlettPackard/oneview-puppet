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

provider_class = Puppet::Type.type(:oneview_drive_enclosure).provider(:synergy)

describe provider_class, unit: true, if: login[:api_version] >= 300 do
  include_context 'shared context'
  api_version = login[:api_version] || 200
  resource_name = 'DriveEnclosure'
  resourcetype = Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}")

  let(:resource) do
    Puppet::Type.type(:oneview_drive_enclosure).new(
      name: 'Enclosure',
      ensure: 'present',
      data:
      {
        'name'  => 'Encl1, bay 1',
        'patch' =>
        {
          'op'    => 'replace',
          'path'  => '/hardResetState',
          'value' => 'Reset'
        },
        'refreshState' => 'RefreshPending'
      },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  before(:each) do
    allow(resourcetype).to receive(:find_by).and_return([test])
    allow_any_instance_of(resourcetype).to receive(:patch).and_return(test)
    provider.exists?
  end

  context 'given the min parameters' do
    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_drive_enclosure).provider(:synergy)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to set the refresh state' do
      allow_any_instance_of(resourcetype).to receive(:set_refresh_state).and_return(true)
      expect(provider.set_refresh_state).to be
    end

    it 'raise an error for the unavailable ensurables' do
      expect { provider.create }.to raise_error(/This resource cannot be created directly./)
      expect { provider.destroy }.to raise_error(/This resource cannot be destroyed directly./)
    end
  end
end
