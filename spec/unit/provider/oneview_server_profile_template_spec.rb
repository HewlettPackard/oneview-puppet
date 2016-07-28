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

# TODO: review and complete with remaining methods for code coverage 80%+
# (additional SPT methods)

require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_server_profile_template).provider(:ruby)

resourcetype = OneviewSDK::ServerProfileTemplate

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'present',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/',
              'type'                  => 'ServerProfileTemplateV1'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile_template).provider(:ruby)
    end

    it 'should run exists? and return the resource does not exist' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return the resource has been found' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    it 'should return that the resource exists' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
    end

    # it 'runs through the create method' do
    #   allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).with(anything, resource['data']).and_return([])
    #   expect(provider.exists?).to eq(false)
    #   expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
    #     .with('/rest/server-profile-templates', { 'body' => resource['data'] }, test.api_version)
    #     .and_return(FakeResponse.new('uri' => '/rest/fake'))
    #   allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/server-profile-templates/100')
    #   expect(provider.create).to eq(true)
    # end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'present',
        data: 'parameter'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should return a hash error' do
      expect { provider.found }
        .to raise_error('Parameter data failed on Oneview_server_profile_template[spt]: Inserted value for data is not valid')
    end
  end

  context 'given the creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'absent',
        data:
            {
              'name' => 'SPT'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    # it 'deletes the resource' do
    #   resource['data']['uri'] = '/rest/fake'
    #   test = resourcetype.new(@client, resource['data'])
    #   allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
    #   expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
    #   expect(provider.exists?).to eq(true)
    #   expect(provider.destroy).to eq(true)
    # end
  end
end
