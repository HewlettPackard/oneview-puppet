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

provider_class = Puppet::Type.type(:oneview_interconnect).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_interconnect).new(
      name: 'interconnect',
      ensure: 'present',
        data:
          {
              'name'    => 'Encl2, interconnect 1',
              'ports'   =>
              {
                'd1' =>
                {
                  'portName'  => 'newName',
                  'available' => 'false'
                }
              }
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_interconnect).provider(:ruby)
  end

  context 'given the min parameters' do

    it 'exists? should return false at first' do
      expect(provider.exists?).to be
    end

    it 'should display the statistics' do
      expect(provider.get_statistics).to be
    end

    it 'should return the interconnect' do
      expect(provider.found).to be
    end

    it 'should display the interconnect schema' do
      expect(provider.get_schema).to be
    end

    it 'should dsplay the interconnect statistics' do
      expect(provider.get_statistics).to be
    end

    it 'should run destroy and display an error' do
      expect(provider.destroy).not_to be
    end

    it 'should run create and display an error' do
      expect(provider.create).not_to be
    end

    it 'should update the interconnect port d1' do
      expect(provider.update_ports).to be
    end

  end


end
