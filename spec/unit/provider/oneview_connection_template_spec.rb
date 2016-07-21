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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_connection_template).provider(:ruby)
resourcetype = OneviewSDK::ConnectionTemplate

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_connection_template).new(
        name: 'Connection Template',
        ensure: 'present',
        data:
            {
              'name' => 'CT'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_connection_template).provider(:ruby)
    end

    it 'should be able to return that the resource exists' do
      allow_any_instance_of(resourcetype).to receive(:retrieve!).and_return(true)
      expect(provider.exists?).to eq(true)
    end

    it 'should be able to get the schema' do
      schema = 'spec/support/fixtures/unit/provider/logical_downlink_schema.json'
      allow_any_instance_of(resourcetype).to receive(:retrieve!).and_return(true)
      expect(provider.exists?).to eq(true)
      allow_any_instance_of(resourcetype).to receive(:schema).and_return(File.read(schema))
      expect(provider.get_schema).to eq(true)
    end

    it 'should be able to find the connection template' do
      allow_any_instance_of(resourcetype).to receive(:retrieve!).and_return(true)
      expect(provider.exists?).to eq(true)
      expect(provider.found).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_connection_template).new(
        name: 'Connection Template',
        ensure: 'get_connection_templates'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to get all the connection templates' do
      test = resourcetype.new(@client, name: 'new ct')
      allow_any_instance_of(resourcetype).to receive(:find_by).with(anything, {}).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.get_connection_templates).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_connection_template).new(
        name: 'Connection Template',
        ensure: 'present',
        data:
        {
          'name' => 'new ct'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should not be able to create the resource' do
      allow_any_instance_of(resourcetype).to receive(:retrieve).and_return(false)
      expect(provider.exists?).to eq(false)
      expect { provider.create }.to raise_error(Puppet::Error, 'This resource cannot be created.')
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_connection_template).new(
        name: 'Connection Template',
        ensure: 'absent',
        data:
        {
          'name' => 'new ct'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should not be able to destroy the resource' do
      allow_any_instance_of(resourcetype).to receive(:retrieve!).and_return(false)
      expect(provider.exists?).to eq(false)
      expect { provider.destroy }.to raise_error(Puppet::Error, 'This resource cannot be destroyed.')
    end
  end
end
