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

provider_class = Puppet::Type.type(:oneview_connection_template).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:ConnectionTemplate, api_version, :C7000)

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
            },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, name: resource['data']['name']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_connection_template).provider(:c7000)
    end

    it 'should be able to be updated' do
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(resource_type).to receive(:like?).and_return(false)
      expect_any_instance_of(resource_type).to receive(:update).and_return(true)
      expect_any_instance_of(resource_type).not_to receive(:create)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should raise an error if no CT matching the passed in exist' do
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(false)
      expect { provider.create }.to raise_error(RuntimeError, /This resource relies on others to be created./)
    end

    it 'should be able to find the connection template' do
      test['uri'] = '/rest/'
      allow(resource_type).to receive(:find_by).and_return([])
      provider.exists?
      allow(resource_type).to receive(:get_default).with(anything).and_return(test)
      expect(provider.get_default_connection_template).to be
    end
  end
end
