################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:image_streamer_plan_script).provider(:image_streamer)
api_version = login_image_streamer[:api_version] || 300
resource_name = 'PlanScript'
resource_type = Object.const_get("OneviewSDK::ImageStreamer::API#{api_version}::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context Image Streamer'

  let(:resource) do
    Puppet::Type.type(:image_streamer_plan_script).new(
      name: 'plan-script-1',
      ensure: 'present',
      data:
          {
            'name'        => 'Plan Script Puppet',
            'description' => 'Description of this plan script',
            'hpProvided'  => false,
            'planType'    => 'deploy',
            'content'     => 'echo "test script"'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the Creation parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider image_streamer' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_plan_script).provider(:image_streamer)
    end

    it 'should run through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should retrieve differences' do
      allow_any_instance_of(resource_type).to receive(:retrieve_differences).and_return(['differences fake response'])
      expect(provider.retrieve_differences).to be
    end

    it 'should retrieve readonly artifacts' do
      allow_any_instance_of(resource_type).to receive(:retrieve_read_only).and_return(['artifacts fake response'])
      expect(provider.retrieve_read_only).to be
    end

    it 'should delete the resource' do
      allow_any_instance_of(resource_type).to receive(:delete).and_return([])
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end
  end
end
