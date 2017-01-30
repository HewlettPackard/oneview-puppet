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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

api_version = login[:api_version] || 200
provider_class = Puppet::Type.type(:oneview_server_profile_template).provider(:c7000)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_server_profile_template).new(
      name: 'Test_SPT',
      ensure: 'present',
      data:
          {
            'name'                  => 'Test_SPT',
            'enclosureGroupUri'     => 'EG',
            'serverHardwareTypeUri' => 'BL460c Gen8 1'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile_template).provider(:c7000)
    end

    it 'exists? should not find the server profile template' do
      expect(provider.exists?).not_to be
    end

    it 'should be able to create a new server profile template' do
      expect(provider.create).to be
    end

    it 'should be able to find the server profile template' do
      expect(provider.found).to be
    end

    it 'should be able to get a server profile template with a new configuration', if: api_version >= 300 do
      resource['data']['queryParameters'] = {
        'enclosureGroupUri'     => 'EG2',
        'serverHardwareTypeUri' => 'BL460c Gen8 1'
      }
      provider.exists?
      expect(provider.get_transformation).to be
    end

    it 'should be able to destroy the server profile template' do
      expect(provider.destroy).to be
    end
  end
end
