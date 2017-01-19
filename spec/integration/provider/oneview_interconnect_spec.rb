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

# you must have the interconnect in your appliance

provider_class = Puppet::Type.type(:oneview_interconnect).provider(:oneview_interconnect)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_interconnect).new(
      name: 'interconnect',
      ensure: 'present',
      data:
          {
            'name' => 'Encl2, interconnect 1',
            'ports' =>
                [
                  {
                    'portName' => 'X1',
                    'enabled' => false
                  }
                ]
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_interconnect).provider(:oneview_interconnect)
  end

  context 'given the min parameters' do
    it 'exists? should return true' do
      expect(provider.exists?).to be
    end

    it 'should display the statistics' do
      expect(provider.get_statistics).to be
    end

    it 'should return the interconnects' do
      expect(provider.found).to be
    end

    it 'should run destroy and display an error' do
      expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
    end

    it 'should run create and display an error' do
      expect { provider.create }.to raise_error('This resource relies on others to be created.')
    end

    it 'should update the interconnect port x1' do
      expect(provider.update_ports).to be
    end
  end
end
