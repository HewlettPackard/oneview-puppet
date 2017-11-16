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

type_class = Puppet::Type.type(:oneview_power_device)

def resource
  {
    name: 'Power Device',
    ensure: 'present',
    data:
        {
          'name' => '172.18.8.11, PDU 1'
        }
  }
end

describe type_class, integration: true do
  let(:params) { %i[name data provider] }

  let(:special_ensurables) { %i[found get_utilization set_refresh_state set_power_state set_uid_state] }

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to include(param)
    end
  end

  it 'should accept special ensurables' do
    special_ensurables.each do |value|
      expect do
        described_class.new(name: 'Test',
                            ensure: value)
      end.to_not raise_error
    end
  end

  it 'should require a name' do
    expect do
      type_class.new({})
    end.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = resource
    modified_config[:data] = ''
    expect do
      type_class.new(modified_config)
    end.to raise_error(Puppet::Error, 'Parameter data failed on Oneview_power_device[Power Device]: Validate method failed for class '\
                                      'data: Inserted value for data is not valid')
  end
end
