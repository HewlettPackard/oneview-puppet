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

type_class = Puppet::Type.type(:oneview_uplink_set)

def uplink_set_config
  {
    name: 'uplink_set_1',
    ensure: 'present',
    data:
        {
          'nativeNetworkUri'               => 'nil',
          'reachability'                   => 'Reachable',
          'manualLoginRedistributionState' => 'NotSupported',
          'connectionMode'                 => 'Auto',
          'lacpTimer'                      => 'Short',
          'networkType'                    => 'Ethernet',
          'ethernetNetworkType'            => 'Tagged',
          'description'                    => 'nil',
          'name'                           => 'Puppet Uplink Set',
          'portConfigInfos' =>
          [
            '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
            'Auto',
            [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
          ]
        },
    network: 'Puppet Test EthNetwork',
    logical_interconnect: 'Encl1-Test Oneview'
  }
end

describe type_class do
  let :params do
    [
      :name,
      :data,
      :provider,
      :network,
      :logical_interconnect,
      :fcoe_network,
      :fc_network
    ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a name' do
    expect do
      type_class.new({})
    end.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = uplink_set_config
    modified_config[:data] = ''
    resource_type = type_class.to_s.split('::')
    expect do
      type_class.new(modified_config)
    end.to raise_error(Puppet::Error, 'Parameter data failed on' \
    " #{resource_type[2]}[#{modified_config[:name]}]: Inserted value for data is not valid")
  end
end
