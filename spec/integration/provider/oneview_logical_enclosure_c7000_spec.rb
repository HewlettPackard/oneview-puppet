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

provider_class = Puppet::Type.type(:oneview_logical_enclosure).provider(:c7000)

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_logical_enclosure).new(
      name: 'Puppet_Test_Enclosure',
      ensure: 'present',
      data:
          {
            'name' => 'Puppet_Test_Enclosure',
            'type' => 'LogicalEnclosure'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider oneview_logical_enclosure' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_enclosure).provider(:c7000)
  end

  context 'given the minimum parameters' do
    it 'should be able to get the script from the logical enclosure' do
      expect(provider.get_script).to be
    end

    it 'should find the logical enclosure' do
      expect(provider.found).to be
    end

    it 'should successfuly run update from group' do
      expect(provider.updated_from_group).to be
    end

    it 'should successfuly run reapply_configuration' do
      expect(provider.reapply_configuration).to be
    end
  end

  context 'given the script parameter' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_enclosure).new(
        name: 'Puppet_Test_Enclosure',
        ensure: 'present',
        data:
            {
              'name'                    => 'Puppet_Test_Enclosure',
              'script'                  => 'This is a script example'
            },
        provider: 'c7000'
      )
    end
    it 'should be able to set the script on the logical enclosure' do
      provider.exists?
      expect(provider.set_script).to be
    end
  end

  context 'given the dump parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_enclosure).new(
        name: 'Puppet_Test_Enclosure',
        ensure: 'generate_support_dump',
        data:
            {
              'name'                    => 'Puppet_Test_Enclosure',
              'dump'                    =>
                  {
                    'errorCode' => 'Mydump',
                    'encrypt' => 'true',
                    'excludeApplianceDump' => 'false'
                  }
            },
        provider: 'c7000'
      )
    end

    it 'should be able to successfully create a dump' do
      provider.exists?
      expect(provider.generate_support_dump).to be
    end
  end
end
