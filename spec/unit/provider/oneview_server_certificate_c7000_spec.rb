################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_server_certificate).provider(:c7000)
api_version = 1800
resource_type = OneviewSDK.resource_named(:ServerCertificate, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context Oneview API 600'

  let(:resource) do
    Puppet::Type.type(:oneview_server_certificate).new(
      name: 'ServerCertificate',
      ensure: 'get_certificate',
      data:
          {
            'aliasName' => '172.18.13.11'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the minimum parameters' do
    before(:each) do
      allow_any_instance_of(resource_type).to receive(:find_by).and_return([test])
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(resource_type).to receive(:like?).and_return(true)
      provider.exists?
    end

    it 'should be an instance of the provider oneview_server_certificate' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_certificate).provider(:c7000)
    end

    it 'should be able to get the certificate request' do
      resource['data']['remoteIp'] = '172.18.13.11'
      allow_any_instance_of(resource_type).to receive(:get_certificate).and_return('test')
      expect(provider.get_certificate).to be
    end

    it 'should be able to retrieve certificates' do
      resource['data']['remoteIp'] = '172.18.13.11'
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
      expect(provider.retrieve).to be
    end

    it 'should be able to remove certificates' do
      resource['data']['remoteIp'] = '172.18.13.11'
      allow_any_instance_of(resource_type).to receive(:remove).and_return(true)
      expect(provider.remove).to be
    end

    it 'should be able to import certificates' do
      resource['data']['remoteIp'] = '172.18.13.11'
      expected_output = {
        'aliasName' => '172.18.13.11',
        'remoteIp' => '172.18.13.11',
        'type' => 'CertificateInfoV2',
        'certificateDetails' =>
         [{
           'type' => 'CertificateDetailV2',
           'base64Data' => 'some certificate data'
         }]
      }
      allow_any_instance_of(resource_type).to receive(:get_certificate).and_return(expected_output)
      allow_any_instance_of(resource_type).to receive(:import).and_return(test)
      expect(provider.import).to be
    end

    it 'should be able to update certificates' do
      resource['data']['remoteIp'] = '172.18.13.11'
      expected_output = {
        'type' => 'CertificateInfoV2',
        'certificateDetails' =>
         [{
           'type' => 'CertificateDetailV2',
           'base64Data' => 'some certificate data'
         }]
      }
      allow_any_instance_of(resource_type).to receive(:get_certificate).and_return(test)
      allow_any_instance_of(resource_type).to receive(:update).and_return(expected_output)
      expect(provider.create_or_update).to be
    end
  end
end
