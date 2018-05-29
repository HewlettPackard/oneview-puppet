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

provider_class = Puppet::Type.type(:oneview_network_set).provider(:c7000)

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_network_set).new(
      name: 'Network Set',
      ensure: 'present',
      data:
          {
            'name' => 'Network Set',
            'networkUris' => %w(Prod_401 BulkEthernetNetwork_1)
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
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_network_set).provider(:c7000)
    end

    it 'should be able to create the resource' do
      expect(provider.create).to be
    end

    it 'should be able to find this resource' do
      expect(provider.found).to be
    end

    it 'should be able to delete the resource' do
      expect(provider.destroy).to be
    end

    it 'should be able to get the resource without ethernet' do
      expect(provider.get_without_ethernet).to be
    end
  end
end
