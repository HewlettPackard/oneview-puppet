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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

provider_class = Puppet::Type.type(:oneview_san_manager).provider(:oneview_san_manager)
san_manager_host = login[:san_manager_host] || '172.18.15.1'
san_manager_username = login[:san_manager_username] || 'dcs'
san_manager_password = login[:san_manager_password] || 'dcs'
san_manager_name = login[:san_manager_name] || 'Brocade Network Advisor'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_san_manager).new(
      name: 'san_manager',
      ensure: 'found',
      data:
          {
            'providerDisplayName' => san_manager_name
          }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider oneview_san_manager' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_san_manager).provider(:oneview_san_manager)
    end

    it 'should raise error when server is not found' do
      resource['data']['providerDisplayName'] = 'Fail Test'
      expect { provider.found }.to raise_error(/No SANManager with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_san_manager).new(
        name: 'san_manager',
        ensure: 'present',
        data:
            {
              'providerDisplayName' => san_manager_name,
              'connectionInfo' => [
                {
                  'name' => 'Host',
                  'value' => san_manager_host
                },
                {
                  'name' => 'Port',
                  'value' => 5989
                },
                {
                  'name' => 'Username',
                  'value' => san_manager_username
                },
                {
                  'name' => 'Password',
                  'value' => san_manager_password
                },
                {
                  'name' => 'UseSsl',
                  'value' => true
                }
              ]
            }
      )
    end
    it 'should create/add the san manager' do
      expect(provider.create).to be
    end
    it 'should be able to run through self.instances' do
      expect(instance).to be
    end
  end

  context 'given the minimum parameters after server creation' do
    it 'should delete the san manager' do
      expect(provider.destroy).to be
    end
  end
end
