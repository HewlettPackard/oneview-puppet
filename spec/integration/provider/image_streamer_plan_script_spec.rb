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

describe provider_class, integration: true do
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

  it 'should be an instance of the provider image streamer' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_plan_script).provider(:image_streamer)
  end

  context 'given the minimum parameters' do
    before(:each) do
      provider.exists?
    end
    it 'exists? should return false at first' do
      expect(provider.exists?).not_to be
    end

    it 'found should return false at first' do
      expect { provider.found }.to raise_error(/No PlanScript with the specified data were found on the Oneview Appliance/)
    end

    it 'should create a new plan script' do
      expect(provider.create).to be
    end
  end
  #
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_plan_script).new(
        name: 'plan-script-2',
        ensure: 'present',
        data:
            {
              'name' => 'Plan Script Puppet'
            }
      )
    end
    before(:each) do
      provider.exists?
    end
    it 'exists? should find a plan script' do
      expect(provider.exists?).to be
    end

    it 'should retrieve the differences' do
      expect(provider.retrieve_differences).to be
    end

    it 'should run destroy' do
      expect(provider.destroy).to be
    end
  end
end
