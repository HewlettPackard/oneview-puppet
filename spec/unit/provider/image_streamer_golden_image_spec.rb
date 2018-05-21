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
api_version = login_image_streamer[:api_version] || 300
resource_name = 'GoldenImage'
resource_type = Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context Image Streamer'

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  let(:provider) { resource.provider }

  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_golden_image).new(
        name: 'golden-image-1',
        ensure: 'present',
        data:
            {
              'name'         => 'Golden_Image_1',
              'description'  => 'Golden Image created from the deployed OS Volume',
              'imageCapture' => true,
              'osVolumeURI'  => 'OSVolumeName',
              'buildPlanUri' => 'BuildPlanName'
            }
      )
    end

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])

      build_plan = OneviewSDK::ImageStreamer::BuildPlan.new(@client, 'name' => 'BuildPlanName')
      allow(OneviewSDK::ImageStreamer::BuildPlan).to receive(:find_by).with(anything, name: 'BuildPlanName').and_return([build_plan])

      os_volume = OneviewSDK::ImageStreamer::OSVolume.new(@client, 'name' => 'OSVolumeName')
      allow(OneviewSDK::ImageStreamer::OSVolume).to receive(:find_by).with(anything, name: 'OSVolumeName').and_return([os_volume])

      provider.exists?
    end

    it 'should be an instance of the provider image_streamer' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_golden_image).provider(:image_streamer)
    end

    it 'should run through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect_any_instance_of(resource_type).to receive(:create).and_return(test)
      expect(provider.create).to be
    end

    it 'should delete the resource' do
      allow_any_instance_of(resource_type).to receive(:delete).and_return([])
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end
  end

  context 'given the Upload parameters' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_golden_image).new(
        name: 'golden-image-1',
        ensure: 'present',
        data:
            {
              'name'         => 'Golden_Image_2',
              'description'  => 'Golden image added from the file that is uploaded from a local drive',
              'golden_image_path' => '/path/to/upload/golden_image.zip'
            }
      )
    end

    let(:expected_data) do
      { 'name' => resource['data']['name'],
        'description' => resource['data']['description'] }
    end

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should upload the file and add the golden image resource with default timeout' do
      allow(resource_type).to receive(:find_by).and_return([])
      timeout = OneviewSDK::Rest::READ_TIMEOUT
      expect(resource_type).to receive(:add).with(anything, '/path/to/upload/golden_image.zip', expected_data, timeout).and_return(test)
      expect(provider.create).to be
    end

    it 'should upload the file and add the golden image resource with given timeout' do
      resource['data']['timeout'] = 7_200
      allow(resource_type).to receive(:find_by).and_return([])
      expect(resource_type).to receive(:add).with(anything, '/path/to/upload/golden_image.zip', expected_data, 7_200).and_return(test)
      expect(provider.create).to be
    end
  end

  context 'given the Archive Download parameters' do
    let(:download_path) { '/path/to/download/details_archive.zip' }

    let(:resource) do
      Puppet::Type.type(:image_streamer_golden_image).new(
        name: 'golden-image-2',
        ensure: 'download_details_archive',
        data:
            {
              'name'                 => 'Golden_Image_1',
              'details_archive_path' => download_path
            }
      )
    end

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    context 'when file does not exist' do
      before(:each) do
        allow(File).to receive(:exist?).with(download_path).and_return(false)
        expect_any_instance_of(resource_type).to receive(:download_details_archive).with(download_path).and_return(true)
      end

      it 'should download the file' do
        expect(provider.download_details_archive).to be
      end

      it 'should download if force is false' do
        resource['data']['force'] = false
        expect(provider.download_details_archive).to be
      end

      it 'should download if force is true' do
        resource['data']['force'] = true
        expect(provider.download_details_archive).to be
      end
    end

    context 'when file already exists' do
      before(:each) do
        allow(File).to receive(:exist?).with(download_path).and_return(true)
      end

      it 'should raise error' do
        expect_any_instance_of(resource_type).not_to receive(:download_details_archive).and_return(true)
        expect { provider.download_details_archive }.to raise_error('File /path/to/download/details_archive.zip already exists.')
      end

      it 'should raise error if force is false' do
        resource['data']['force'] = false
        expect_any_instance_of(resource_type).not_to receive(:download_details_archive).and_return(true)
        expect { provider.download_details_archive }.to raise_error('File /path/to/download/details_archive.zip already exists.')
      end

      it 'should download if force is true' do
        resource['data']['force'] = true
        expect_any_instance_of(resource_type).to receive(:download_details_archive).with(download_path).and_return(true)
        expect(provider.download_details_archive).to be
      end
    end
  end

  context 'given the Download parameters' do
    let(:download_path) { '/path/to/download/golden_image.zip' }

    let(:resource) do
      Puppet::Type.type(:image_streamer_golden_image).new(
        name: 'golden-image-2',
        ensure: 'download',
        data:
            {
              'name'                       => 'Golden_Image_1',
              'golden_image_download_path' => download_path
            }
      )
    end

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    context 'when file does not exist' do
      before(:each) do
        allow(File).to receive(:exist?).with(download_path).and_return(false)
        expect_any_instance_of(resource_type).to receive(:download).with(download_path).and_return(true)
      end

      it 'should download the file' do
        expect(provider.download).to be
      end

      it 'should download if force is false' do
        resource['data']['force'] = false
        expect(provider.download).to be
      end

      it 'should download if force is true' do
        resource['data']['force'] = true
        expect(provider.download).to be
      end
    end

    context 'when file already exists' do
      before(:each) do
        allow(File).to receive(:exist?).with(download_path).and_return(true)
      end

      it 'should raise error' do
        expect_any_instance_of(resource_type).not_to receive(:download).and_return(true)
        expect { provider.download }.to raise_error('File /path/to/download/golden_image.zip already exists.')
      end

      it 'should raise error if force is false' do
        resource['data']['force'] = false
        expect_any_instance_of(resource_type).not_to receive(:download).and_return(true)
        expect { provider.download }.to raise_error('File /path/to/download/golden_image.zip already exists.')
      end

      it 'should download if force is true' do
        resource['data']['force'] = true
        expect_any_instance_of(resource_type).to receive(:download).with(download_path).and_return(true)
        expect(provider.download).to be
      end
    end
  end
end
