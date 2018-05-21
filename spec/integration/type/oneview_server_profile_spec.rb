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

type_class = Puppet::Type.type(:oneview_server_profile)

def config
  {
    name: 'Server Profile',
    ensure: 'present',
    data:
    {
      'name' => 'Server Profile'
    }
  }
end

describe type_class, integration: true do
  let(:params) { %i[name data provider] }

  let :special_ensurables do
    %i[
      found get_available_servers get_available_storage_systems get_available_storage_system
      get_profile_ports get_messages get_available_networks get_compliance_preview
      get_available_targets
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
    modified_config = config
    modified_config[:data] = ''
    expect do
      type_class.new(modified_config)
    end.to raise_error(Puppet::ResourceError, 'Parameter data failed on Oneview_server_profile[Server Profile]: '\
                                               'Validate method failed for class data: Inserted value for data is not valid')
  end
end
