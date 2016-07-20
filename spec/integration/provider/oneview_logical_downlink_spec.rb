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
provider_class = Puppet::Type.type(:oneview_logical_downlink).provider(:ruby)

# you must have this logical downlink in your appliance
name = 'LDc3330ee6-8b74-4eaf-9e5d-b14eeb5340b4 (HP VC FlexFabric-20/40 F8 Module)'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_logical_downlink).new(
      name: 'Logical Downlink',
      ensure: 'get_logical_downlinks',
      data:
      {
        name: name
      }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_downlink).provider(:ruby)
  end

  context 'given the min parameters' do
    it 'exists? should return true' do
      expect(provider.exists?).to be
    end

    it 'should not be able to create the resource' do
      expect(provider.create).not_to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_logical_downlinks',
        data:
        {
          name: name
        }
      )
    end

    it 'should be able to find the resource' do
      expect(provider.exists?).to be
      expect(provider.found).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_schema',
        data:
        {
          name: name
        }
      )
    end

    it 'should be able to get the logical downlink schema' do
      expect(provider.exists?).to be
      expect(provider.get_schema).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_schema',
        data:
        {
          name: name
        }
      )
    end

    it 'should be able to get the logical downlink without ethernet' do
      expect(provider.exists?).to be
      expect(provider.get_without_ethernet).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_logical_downlinks',
        data:
        {
          name: name
        }
      )
    end

    it 'should be able to get the logical downlink without ethernet' do
      expect(provider.exists?).to be
      expect(provider.get_logical_downlinks).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'absent',
        data:
        {
          name: name
        }
      )
    end

    it 'should not be able to delete the resource' do
      expect(provider.destroy).not_to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'present',
        data:
        {
          name: 'Test Logical Downlink'
        }
      )
    end

    it 'should not be able to perform actions' do
      expect(provider.exists?).not_to be
      expect { provider.found }.to raise_error
    end
  end
end
