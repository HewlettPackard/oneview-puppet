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

provider_class = Puppet::Type.type(:oneview_server_profile_template).provider(:ruby)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_server_profile_template).new(
      name: 'Test_SPT',
      ensure: 'present',
      data:
          {
            'name'                  => 'Test_SPT',
            'enclosureGroupUri'     => '/rest/enclosure-groups/85a4045d-8e5a-4787-894e-a5e404098944',
            'serverHardwareTypeUri' => '/rest/server-hardware-types/1D614B25-4119-40F6-A71B-EAF01E325A3A'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile_template).provider(:ruby)
    end

    it 'exists? should not find the server profile template' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the server profile template was not found' do
      expect(provider.found).not_to be
    end

    it 'should be able to create a new server profile template' do
      expect(provider.create).to be
    end

    it 'should be able to find the server profile template' do
      expect(provider.found).to be
    end

    it 'should be able to destroy the server profile template' do
      expect(provider.destroy).to be
    end
  end
end
