################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

type_class = Puppet::Type.type(:image_streamer_artifact_bundle)

def plan_script_config
  {
    name: 'artifact_bundle_1',
    ensure: 'present',
    data:
        {
          'name' => 'Artifact Bundle name'
        }
  }
end

describe type_class, integration: true do
  let(:test) { resource_type.new(@client, resource['data']) }
  let(:params) { %i[name data provider] }

  let(:special_ensurables) { %i[found extract download get_backups create_backup] }

  it 'should accept special ensurables' do
    special_ensurables.each do |value|
      expect { described_class.new(name: 'Test', ensure: value, data: {}) }.to_not raise_error
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to include(param)
    end
  end

  it 'should require a name' do
    expect { type_class.new({}) }.to raise_error(Puppet::Error, /Title or name must be provided/)
  end

  it 'should require a data hash' do
    modified_config = plan_script_config
    modified_config[:data] = 5
    expect { type_class.new(modified_config) }.to raise_error(Puppet::Error, /Inserted value for data is not valid/)
  end
end
