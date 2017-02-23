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
require_relative '../../../lib/puppet/provider/uri_parsing.rb'

describe 'uri_parsing', unit: true do
  describe 'given Image Streamer resources' do
    include_context 'shared context Image Streamer'

    let(:resource_variant) { 'does not apply' }

    let(:golden_image_name) { 'Golden Image Name' }

    let(:golden_image_uri) { '/rest/uri/golden-images/fake' }

    let(:golden_image) do
      OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client, 'name' => golden_image_name, 'uri' => golden_image_uri)
    end

    before(:each) do
      golden_image_type = OneviewSDK::ImageStreamer::API300::GoldenImage
      allow(golden_image_type).to receive(:find_by).with(anything, name: golden_image_name).and_return([golden_image])
    end

    it 'should replace resource name by uri' do
      data = { 'goldenImageUri' => golden_image_name }
      expect(uri_validation(data)).to eq 'goldenImageUri' => golden_image_uri
    end

    it 'should replace resource name by uri using recursion' do
      data = { 'goldenImageUri' => golden_image_name,
               'value'          => { 'goldenImageUri' => golden_image_name,
                                     'list'           => ['goldenImageUri' => golden_image_name] } }

      expected_result = { 'goldenImageUri' => golden_image_uri,
                          'value'          => { 'goldenImageUri' => golden_image_uri,
                                                'list'           => ['goldenImageUri' => golden_image_uri] } }

      expect(uri_validation(data)).to eq expected_result
    end

    it 'should replace resource name by uri when key is named resourceUri' do
      data = { 'resourceUri' => "#{golden_image_name},GoldenImage" }

      expected_result = { 'resourceUri' => golden_image_uri }
      expect(uri_validation(data)).to eq expected_result
    end

    it 'should get the classname to find the resource' do
      expect(get_class('goldenImageUri')).to eq OneviewSDK::ImageStreamer::API300::GoldenImage
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end

  describe 'given OneView resources and API Version 300' do
    include_context 'shared context'

    let(:resource_variant) { 'C7000' }

    let(:enclosure_name) { 'Enclosure Name' }

    let(:enclosure_uri) { '/rest/uri/enclosures/fake' }

    let(:enclosure) do
      OneviewSDK::API300::C7000::Enclosure.new(@client, 'name' => enclosure_name, 'uri' => enclosure_uri)
    end

    before(:each) do
      allow(OneviewSDK::API300::C7000::Enclosure).to receive(:find_by).with(anything, name: 'Enclosure Name').and_return([enclosure])
    end

    it 'should replace resource name by uri' do
      data = { 'enclosureUri' => enclosure_name }
      expect(uri_validation(data)).to eq 'enclosureUri' => enclosure_uri
    end

    it 'should replace resource name by uri using recursion' do
      data = { 'enclosureUri' => enclosure_name,
               'value'          => { 'enclosureUri' => enclosure_name,
                                     'list'         => ['enclosureUri' => enclosure_name] } }

      expected_result = { 'enclosureUri' => enclosure_uri,
                          'value'        => { 'enclosureUri' => enclosure_uri,
                                              'list'         => ['enclosureUri' => enclosure_uri] } }

      expect(uri_validation(data)).to eq expected_result
    end

    it 'should replace resource name by uri when key is named resourceUri' do
      data = { 'resourceUri' => "#{enclosure_name},Enclosure" }
      expect(uri_validation(data)).to eq 'resourceUri' => enclosure_uri
    end

    it 'should get the classname to find the resource' do
      expect(get_class('enclosureUri')).to eq OneviewSDK::API300::C7000::Enclosure
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end

  describe 'given OneView resources and API Version 200' do
    include_context 'shared context OneView API 200'

    let(:resource_variant) { 'C7000' }

    let(:enclosure_name) { 'Enclosure Name' }

    let(:enclosure_uri) { '/rest/uri/enclosures/fake' }

    let(:enclosure) do
      OneviewSDK::API200::Enclosure.new(@client, 'name' => enclosure_name, 'uri' => enclosure_uri)
    end

    before(:each) do
      allow(OneviewSDK::API200::Enclosure).to receive(:find_by).with(anything, name: 'Enclosure Name').and_return([enclosure])
    end

    it 'should replace resource name by uri' do
      data = { 'enclosureUri' => enclosure_name }
      expect(uri_validation(data)).to eq 'enclosureUri' => enclosure_uri
    end

    it 'should replace resource name by uri using recursion' do
      data = { 'enclosureUri' => enclosure_name,
               'value'          => { 'enclosureUri' => enclosure_name,
                                     'list'         => ['enclosureUri' => enclosure_name] } }

      expected_result = { 'enclosureUri' => enclosure_uri,
                          'value'        => { 'enclosureUri' => enclosure_uri,
                                              'list'         => ['enclosureUri' => enclosure_uri] } }

      expect(uri_validation(data)).to eq expected_result
    end

    it 'should replace resource name by uri when key is named resourceUri' do
      data = { 'resourceUri' => "#{enclosure_name},Enclosure" }
      expect(uri_validation(data)).to eq 'resourceUri' => enclosure_uri
    end

    it 'should get the classname to find the resource' do
      expect(get_class('enclosureUri')).to eq OneviewSDK::API200::Enclosure
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end
end
