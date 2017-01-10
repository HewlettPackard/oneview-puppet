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

provider_class = Puppet::Type.type(:oneview_datacenter).provider(:c7000)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_datacenter).new(
      name: 'Test Datacenter',
      ensure: 'present',
      data:
          {
            'name' => 'Test Datacenter',
            'width' => '4000',
            'depth' => '5000'
          }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_datacenter).provider(:c7000)
  end

  it 'should not be able to find the resource' do
    expect(provider.exists?).not_to be
  end

  it 'should be able to add the resource' do
    expect(provider.create).to be
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_datacenter).new(
        name: 'Test Datacenter',
        ensure: 'present',
        data:
            {
              'name' => 'Test Datacenter'
            }
      )
    end

    it 'should be able to find the resource' do
      expect(provider.exists?).to be
      expect(provider.found).to be
    end

    it 'should be able to get the visual content' do
      expect(provider.get_visual_content).to be
    end

    it 'should be able to remove the resource' do
      expect(provider.destroy).to be
    end
  end
end
