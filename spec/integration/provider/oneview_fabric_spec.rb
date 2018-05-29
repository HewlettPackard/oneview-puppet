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

provider_class = Puppet::Type.type(:oneview_fabric).provider(:c7000)

# you must have the DefaultFabric in the Appliance

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_fabric).new(
      name: 'Fabric',
      ensure: 'present',
      data:
      {
        'name' => 'DefaultFabric'
      }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider C7000' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fabric).provider(:c7000)
  end

  it 'should be able to find the fabric' do
    expect(provider.found).to be
  end

  it 'should not be able to create the fabric' do
    expect { provider.create }.to raise_error('This resource relies on others to be created.')
  end

  it 'should not be able to destroy the fabric' do
    expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
  end
end
