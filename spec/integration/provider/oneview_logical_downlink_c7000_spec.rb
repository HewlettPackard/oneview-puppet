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

provider_class = Puppet::Type.type(:oneview_logical_downlink).provider(:synergy)

# you must have this logical downlink in your appliance
name = 'LDc3330ee6-8b74-4eaf-9e5d-b14eeb5340b4 (HP VC FlexFabric-20/40 F8 Module)'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_logical_downlink).new(
      name: 'Logical Downlink',
      ensure: 'found',
      data:
      {
        name: name
      },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider c7000' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_downlink).provider(:c7000)
  end

  context 'given the min parameters' do
    it 'exists? should return true' do
      expect(provider.exists?).to be
    end

    it 'should not be able to create/destroy the resource' do
      expect { provider.create }.to raise_error('This resource relies on others to be created.')
      expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
    end

    it 'should be able to find the resource' do
      provider.exists?
      expect(provider.found).to be
    end

    it 'should be able to get the logical downlink without ethernet' do
      provider.exists?
      expect(provider.get_without_ethernet).to be
    end
  end
end
