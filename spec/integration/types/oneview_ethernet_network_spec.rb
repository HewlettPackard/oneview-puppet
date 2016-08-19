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

type_class = Puppet::Type.type(:oneview_ethernet_network)

def resource_config
  {
    name: 'Test Ethernet Network',
    data:
        {
          'name' => 'Puppet Network',
          'vlanId' => '100',
          'purpose' => 'General',
          'smartLink' => 'false',
          'privateNetwork' => 'true',
          'connectionTemplateUri' => 'nil',
          'type' => 'ethernet-networkV3'
        }
  }
end

describe type_class do
  let :params do
    [
      :name,
      :data,
      :provider
    ]
  end

  let :special_ensurables do
    [
      :found,
      :get_associated_profiles,
      :get_associated_uplink_groups
    ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to include(param)
    end
  end

  it 'should accept special ensurables' do
    special_ensurables.each do |value|
      expect do
        described_class.new(name: 'Test',
                            ensure: value,
                            data: {})
      end.to_not raise_error
    end
  end

  it 'should require a name' do
    expect do
      type_class.new({})
    end.to raise_error('Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = resource_config
    modified_config[:data] = ''
    expect do
      type_class.new(modified_config)
    end.to raise_error(Puppet::ResourceError, 'Parameter data failed on Oneview_ethernet_network[Test Ethernet Network]: '\
                                              'Validate method failed for class data: Inserted value for data is not valid')
  end
end
