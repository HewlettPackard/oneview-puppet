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

    it 'should get the classname to find a resource' do
      expect(get_class('goldenImageUri')).to eq OneviewSDK::ImageStreamer::API300::GoldenImage
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end

  describe 'given OneView resources' do
    include_context 'shared context'

    it 'should get the classname to find a resource' do
      expect(get_class('enclosureUri')).to eq OneviewSDK::Enclosure
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end
end
