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

provider_class = Puppet::Type.type(:oneview_volume_attachment).provider(:oneview_volume_attachment)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_volume_attachment).new(
      name: 'Volume Template',
      ensure: 'present',
      data:
          {
            'name' => 'ONEVIEW_PUPPET_TEST'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_volume_attachment' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume_attachment).provider(:oneview_volume_attachment)
    end

    it 'exists? should find the volume template' do
      expect(provider.exists?).to be
    end

    it 'should do nothing (it is unavailable) and always return true as it is' do
      expect(provider.create).to be
    end
    # This requires the VA to be created beforehand
    # it 'should return that the volume template was found' do
    #   expect(provider.found).to be
    # end

    it 'should return the list of extra unmanaged volumes' do
      expect(provider.get_extra_unmanaged_volumes).to be
    end

    it 'should be able to remove extra unmanaged volumes' do
      expect(provider.remove_extra_unmanaged_volume).to be
    end

    it 'should return the list of paths from the VA' do
      expect(provider.get_paths).to be
    end

    it 'should do nothing (it is unavailable) and always return true as it is' do
      expect(provider.destroy).to be
    end
  end
end
