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

type_class = Puppet::Type.type(:oneview_enclosure_group)

def enclosure_group_config
{
  name: 'Enclosure Group',
  ensure: 'present',
    data:
      {
        'name'                         =>'Enclosure Group',
        'interconnectBayMappingCount'  => 8,
        'stackingMode'                 =>'Enclosure',
        'type'                         =>'EnclosureGroupV200',
        'interconnectBayMappings'      =>
        [
          {
            'interconnectBay' => "1",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "2",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "3",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "4",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "5",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "6",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "7",
            'logicalInterconnectGroupUri' => nil
          },
          {
            'interconnectBay' => "8",
            'logicalInterconnectGroupUri' => nil
          }
        ]
      }
}
end

describe type_class do

  let :params do
  [
    :name,
    :data,
    :provider,
  ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a name' do
    expect {
      type_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = enclosure_group_config
    modified_config[:data] = ''
    resource_type = type_class.to_s.split('::')
    expect {
        type_class.new(modified_config)
    }.to raise_error(Puppet::Error, "Parameter data failed on" +
    " #{resource_type[2]}[#{modified_config[:name]}]: Invalid Data Hash")
  end

end
