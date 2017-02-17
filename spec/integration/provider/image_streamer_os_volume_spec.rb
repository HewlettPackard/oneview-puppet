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

provider_class = Puppet::Type.type(:image_streamer_os_volume).provider(:image_streamer)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:image_streamer_os_volume).new(
      name: 'os-volume-1',
      ensure: 'found',
      data:
          {
            'name' => 'Volume_absent'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider image streamer' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_os_volume).provider(:image_streamer)
  end

  context 'given the minimum parameters' do
    it 'exists? should return false when the volume is absent' do
      expect(provider.exists?).not_to be
    end

    it 'found should raise an error when the volume is absent' do
      expect { provider.found }.to raise_error(/No OSVolume with the specified data were found on the Oneview Appliance/)
    end

    it 'create should display unavailable method' do
      expect { provider.create }.to raise_error(/This ensurable is not supported for this resource./)
    end

    it 'destroy should display unavailable method' do
      expect { provider.destroy }.to raise_error(/This ensurable is not supported for this resource./)
    end
  end

  context 'given an existing OS Volume' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_os_volume).new(
        name: 'os-volume-2',
        ensure: 'found',
        data:
            {
              'name' => 'OSVolume-6'
            }
      )
    end
    it 'exists? should find a volume' do
      expect(provider.exists?).to be
    end

    it 'should retrieve the details of the archived volume' do
      expect(provider.get_details_archive).to be
    end
  end
end
