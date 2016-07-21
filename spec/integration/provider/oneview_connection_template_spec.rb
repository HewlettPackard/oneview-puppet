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

provider_class = Puppet::Type.type(:oneview_connection_template).provider(:ruby)

# you must have this connection template in your appliance

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_connection_template).new(
      name: 'Connection Template',
      ensure: 'present',
      data:
      {
        name: 'CT'
      }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_connection_template).provider(:ruby)
  end

  it 'should be able to get the default connection template' do
    expect(provider.get_default_connection_template).to be
  end

  it 'should be able to get all the connection templates' do
    expect(provider.get_connection_templates).to be
  end

  it 'should be able to get the schema' do
    expect(provider.get_schema).to be
  end

  it 'should be able to find the connection template when it exists' do
    expect(provider.exists?).to be
    expect(provider.found).to be
  end

  context 'giving the minumum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_connection_template).new(
        name: 'Connection Template',
        ensure: 'present',
        data:
        {
          name: 'Another CT'
        }
      )
    end

    before(:each) do
      provider.exists?
    end

    it 'should not be able to find the connection template when it does not exits' do
      expect { provider.found }.to raise_error(Puppet::Error, 'This resource cannot be found.')
    end

    it 'should not be able to create the resource' do
      expect { provider.create }.to raise_error(Puppet::Error, 'This resource cannot be created.')
    end

    it 'should not be able to destroy the resource' do
      expect { provider.destroy }.to raise_error(Puppet::Error, 'This resource cannot be destroyed.')
    end
  end
end
