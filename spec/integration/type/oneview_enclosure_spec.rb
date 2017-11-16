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

type_class = Puppet::Type.type(:oneview_enclosure)

def enclosure_config
  {
    name: 'Enclosure',
    ensure: 'present',
    data:
        {
          'name'              => 'Puppet_Test_Enclosure',
          'hostname'          => '172.18.1.13',
          'username'          => 'dcs',
          'password'          => 'dcs',
          'enclosureGroupUri' => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
          'licensingIntent'   => 'OneView'
        }
  }
end

describe type_class, integration: true do
  let(:params) { %i[name data provider] }

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
    modified_config = enclosure_config
    modified_config[:data] = ''
    resource_type = type_class.to_s.split('::')
    expect do
      type_class.new(modified_config)
    end.to raise_error('Parameter data failed on' \
    " #{resource_type[2]}[#{modified_config[:name]}]: Validate method failed for class data: Inserted value for data is not valid")
  end
end
