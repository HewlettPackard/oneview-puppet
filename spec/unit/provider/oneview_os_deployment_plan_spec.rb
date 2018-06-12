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

provider_class = Puppet::Type.type(:oneview_os_deployment_plan).provider(:synergy)
api_version = login[:api_version] || 300
resource_type = OneviewSDK.resource_named(:OSDeploymentPlan, api_version, :Synergy)

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_os_deployment_plan).new(
      name: 'os_deployment_plan',
      ensure: 'found',
      data:
          {
            'name' => 'OS_DP1'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_os_deployment_plan).provider(:synergy)
    end

    it 'should be able to run self.instances' do
      expect(instance).to be
    end

    it 'should find the resource' do
      allow(resource_type)
      expect(provider.found).to be
    end
  end
end
