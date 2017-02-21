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

provider_class = Puppet::Type.type(:image_streamer_golden_image).provider(:image_streamer)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:image_streamer_golden_image).new(
      name: 'golden-image-1',
      ensure: 'present',
      data:
          {
            'name'         => 'Golden_Image_1',
            'description'  => 'Golden Image created from the deployed OS Volume',
            'imageCapture' => true,
            'osVolumeURI'  => 'OSVolume-7',
            'buildPlanUri' => 'Build Plan Name'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider image streamer' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_golden_image).provider(:image_streamer)
  end

  context 'given the minimum parameters' do
    it 'exists? should return false at first' do
      expect(provider.exists?).not_to be
    end

    it 'found should raise error when golden image not found' do
      expect { provider.found }.to raise_error(/No GoldenImage with the specified data were found on the Oneview Appliance/)
    end

    it 'should create a new golden image' do
      expect(provider.create).to be
    end
  end
  #
  context 'given the golden image exists' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_golden_image).new(
        name: 'golden-image-2',
        ensure: 'present',
        data:
            {
              'name' => 'Golden_Image_1'
            }
      )
    end

    it 'exists? should find a golden image' do
      expect(provider.exists?).to be
    end

    it 'should run destroy' do
      expect(provider.destroy).to be
    end
  end

  context 'given the golden image upload' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_golden_image).new(
        name: 'golden-image-2',
        ensure: 'present',
        data:
            {
              'name'              => 'Golden_Image_2',
              'description'       => 'Golden image added from the file that is uploaded from a local drive',
              'golden_image_path' => 'spec/support/fixtures/integration/provider/golden_image.zip'
            }
      )
    end
    it 'create should add the file' do
      expect(provider.create).to be
    end

    it 'exists? should find a golden image' do
      expect(provider.exists?).to be
    end

    it 'should run destroy' do
      expect(provider.destroy).to be
    end
  end
end
