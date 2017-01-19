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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_connection_template).provider(:c7000)
api_version = login[:api_version] || 200
resourcetype ||= if api_version == 200
                   OneviewSDK::API200::ConnectionTemplate
                 else
                   Object.const_get("OneviewSDK::API#{api_version}::C7000::ConnectionTemplate")
                 end

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

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_connection_template).provider(:c7000)
    end

    it 'should return that the resource exists' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
    end

    it 'should be able to find the connection template' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    it 'should be able to find the connection template' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      test['uri'] = '/rest/'
      allow(resourcetype).to receive(:find_by).and_return([])
      provider.exists?
      allow(resourcetype).to receive(:get_default).with(anything).and_return(test)
      expect(provider.get_default_connection_template).to be
    end

    it 'should not be able to create the resource' do
      expect { provider.create }.to raise_error('This resource relies on others to be created.')
    end

    it 'should not be able to destroy the resource' do
      expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
    end
  end
end
