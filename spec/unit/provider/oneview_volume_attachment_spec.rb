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

provider_class = Puppet::Type.type(:oneview_volume_attachment).provider(:oneview_volume_attachment)
resourcetype = OneviewSDK::VolumeAttachment

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_volume_attachment).new(
      name: 'VA',
      ensure: 'present',
      data:
          {
            'name' => 'Server Profile Attachment Demo, volume-attachment-demo'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, {}).and_return([test])
      expect(instance).to be
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume_attachment).provider(:oneview_volume_attachment)
    end

    it 'should able to find the specific VA' do
      resource['data']['sanStorage'] = { 'volumeAttachments' => [{ 'volumeUri' => 'fake uri' }] }
      resource['data']['uri'] = 'fake uri'
      test = resourcetype.new(@client, resource['data'])
      resource['data'].delete('sanStorage')
      resource['data'].delete('uri')
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(OneviewSDK::ServerProfile).to receive(:find_by).with(anything, name: 'Server Profile Attachment Demo').and_return([test])
      allow(OneviewSDK::Volume).to receive(:find_by).with(anything, name: 'volume-attachment-demo').and_return([test])
      expect(provider.found).to be
    end

    it 'should raise an error if the ensurable present is used' do
      resource['ensure'] = 'present'
      expect { provider.create }.to raise_error(/Ensure state 'present' is unavailable for this resource/)
    end

    it 'should raise an error if the ensurable absent is used' do
      resource['ensure'] = 'absent'
      expect { provider.destroy }.to raise_error(/Ensure state 'absent' is unavailable for this resource/)
    end

    it 'should be able to get a list of extra unmanaged volumes' do
      resource['ensure'] = 'get_extra_unmanaged_volumes'
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new('members' => %w(first second)))
      expect(provider.get_extra_unmanaged_volumes).to be
    end

    it 'should be able to remove the extra unmanaged volumes' do
      resource['ensure'] = 'remove_extra_unmanaged_volume'
      test = resourcetype.new(@client, resource['data'])
      body = { type: 'ExtraUnmanagedStorageVolumes', resourceUri: resource['data']['uri'] }
      allow(OneviewSDK::ServerProfile).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/storage-volume-attachments/repair', 'body' => body)
        .and_return(FakeResponse.new('uri' => '/rest/fake'))
      # expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new({'members' => ['first','second']}))
      expect(provider.remove_extra_unmanaged_volume).to be
    end
  end

  context 'given no data' do
    let(:resource) do
      Puppet::Type.type(:oneview_volume_attachment).new(
        name: 'VA',
        ensure: 'found'
      )
    end
    it 'should able to find all VAs' do
      test = resourcetype.new(@client, {})
      allow(resourcetype).to receive(:find_by).with(anything, {}).and_return([test])
      expect(provider.found).to be
    end
  end

  context 'given the get paths attributes' do
    let(:resource) do
      Puppet::Type.type(:oneview_volume_attachment).new(
        name: 'VA',
        ensure: 'get_paths',
        data:
            {
              'name' => 'ONEVIEW_PUPPET_TEST VA1',
              'id'   => 'fake'
            }
      )
    end

    it 'should be able to get all paths if no id is provided' do
      resource['data'] = { 'name' => 'ONEVIEW_PUPPET_TEST VA1' }
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(%w(fake_path_1 fake_path_2)))
      provider.exists?
      expect(provider.get_paths).to be
    end

    it 'should be able to get a path by id if id is provided' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(['fake_path_found']))
      provider.exists?
      expect(provider.get_paths).to be
    end
  end
end
