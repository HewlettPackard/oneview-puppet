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
api_version = login_image_streamer[:api_version] || 300
resource_name = 'OSVolume'
resourcetype = Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context Image Streamer'

  let(:resource) do
    Puppet::Type.type(:image_streamer_os_volume).new(
      name: 'os-volume-1',
      ensure: 'found',
      data:
        {
          'name' => 'OSVolume-14'
        }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  before(:each) do
    allow(resourcetype).to receive(:find_by).and_return([test])
    provider.exists?
  end

  context 'given the found parameters' do
    it 'should be an instance of the provider image_streamer' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_os_volume).provider(:image_streamer)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'create should display unavailable method' do
      expect { provider.create }.to raise_error(/This ensurable is not supported for this resource./)
    end

    it 'destroy should display unavailable method' do
      expect { provider.destroy }.to raise_error(/This ensurable is not supported for this resource./)
    end

    it 'should retrieve the details of the archived volume' do
      expect_any_instance_of(resourcetype).to receive(:get_details_archive).and_return(['details of archive'])
      expect(provider.get_details_archive).to be
    end
  end
end
