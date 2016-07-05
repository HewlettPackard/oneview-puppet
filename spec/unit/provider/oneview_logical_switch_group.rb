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

provider_class = Puppet::Type.type(:oneview_logical_switch_group).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_logical_switch_group).new(
      name: 'Test Logical Switch Group',
    ensure: 'present',
        data:
          {
              'name'                    => 'Test LSG',
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_switch_group).provider(:ruby)
  end

  it 'should return the LSG does not exist' do
    expect(provider.exists?).not_to be
  end

  it 'should create the LSG' do
    expect(provider.create).to be
  end

  it 'should find the LSG' do
    expect(provider.found).to be
  end

  it 'should get the schema of the LSG' do
    expect(provider.get_schema).to be
  end

  it 'should return all the LSGs' do
    expect(provider.get_logical_switch_groups).to be
  end

  it 'should destroy the LSG' do
    expect(provider.destroy).to be
  end

end
