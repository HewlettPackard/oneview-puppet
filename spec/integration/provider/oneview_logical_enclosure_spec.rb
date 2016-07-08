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

provider_class = Puppet::Type.type(:oneview_logical_enclosure).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_logical_enclosure).new(
      name: 'Test Logical Enclosure',
    ensure: 'present',
        data:
          {
              'name'                    => 'Encl1',
              'type'                    => 'LogicalEnclosure'
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_enclosure).provider(:ruby)
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

  end

  let(:resource_with_script) {
    Puppet::Type.type(:oneview_logical_enclosure).new(
      name: 'Test Logical Enclosure',
      ensure: 'present',
      data:
          {
              'name'                    => 'Encl1',
              'script'                  => 'This is a script example',
          },
    )
  }

  context 'given the script parameter' do

    it 'should be able to set the script on the logical enclosure' do
      expect(provider.set_script).to be
    end

  end

  # FIXME This for some unknown reason is giving out a runtime error related to
  # the URI 'Must specify a task_uri!', leaving dump test commented till fixed.
  # let(:resource_with_dump) {
  #   Puppet::Type.type(:oneview_logical_enclosure).new(
  #     name: 'Test Logical Enclosure',
  #     ensure: 'dumped',
  #     data:
  #         {
  #             'name'                    => 'Encl1',
  #             'dump'                    =>
  #               {
  #                 'errorCode' => 'Mydump',
  #                 'encrypt' => 'false',
  #                 'excludeApplianceDump' => 'false',
  #               },
  #         },
  #   )
  # }
  #
  # context 'given the dump parameters' do
  #
  #   it 'should be able to successfully create a dump' do
  #     expect(provider.dumped).to be
  #   end
  #
  # end

end
