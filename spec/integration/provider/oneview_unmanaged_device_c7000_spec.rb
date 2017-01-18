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

provider_class = Puppet::Type.type(:oneview_unmanaged_device).provider(:c7000)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_unmanaged_device).new(
      name: 'Test UD',
      ensure: 'present',
      data:
          {
            'name' => 'Test Datacenter',
            'model' => 'Procurve 4200VL',
            'deviceType' => 'Server'
          },
      provider: 'c7000'
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider c7000' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_unmanaged_device).provider(:c7000)
  end

  it 'should be able to add the unmanaged device' do
    expect(provider.create).to be
  end

  it 'should be able to find the unmanaged devices' do
    expect(provider.found).to be
  end

  it 'should be able to get the environmental configuration' do
    expect(provider.get_environmental_configuration).to be
  end

  it 'should be able to remove the unmanaged device' do
    expect(provider.destroy).to be
  end
end
