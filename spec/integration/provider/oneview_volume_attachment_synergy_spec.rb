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

# NOTE: For all tests in this spec to pass, the volume attachment specified must
# have unmanaged volumes in it.

require 'spec_helper'
require_relative '../../../lib/puppet/provider/login'

provider_class = Puppet::Type.type(:oneview_volume_attachment).provider(:synergy)
storage_volume_template = login[:storage_volume_template] || 'Test'
server_profile_name = login[:server_profile_name] || 'OneViewSDK Test ServerProfile'
volume_name = login[:volume_name] || 'Volume Test'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_volume_attachment).new(
      name: 'Volume Attachment',
      ensure: 'present',
      data:
          {
            'name' => "#{storage_volume_template}, #{volume_name}"
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_volume_attachment' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume_attachment).provider(:synergy)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    # This requires the VA to be created beforehand
    # it 'should return that the volume attachment was found' do
    #   expect(provider.found).to be
    # end

    it 'should return the list of extra unmanaged volumes' do
      expect(provider.get_extra_unmanaged_volumes).to be
    end

    it 'should be able to remove extra unmanaged volumes' do
      resource['data']['name'] = server_profile_name
      expect(provider.remove_extra_unmanaged_volume).to be
    end

    it 'should return the list of paths from the VA' do
      expect(provider.get_paths).to be
    end
  end
end
