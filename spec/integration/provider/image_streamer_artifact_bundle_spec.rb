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

provider_class = Puppet::Type.type(:image_streamer_artifact_bundle).provider(:image_streamer)

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:image_streamer_artifact_bundle).new(
      name: 'artifact-bundle-1',
      ensure: 'present',
      data:
          {
            'name'        => 'Artifact_Bundle_Puppet',
            'description' => 'Artifact Bundle with a Plan Script Artifact',
            'planScripts' => [{
              'resourceUri' => 'Plan Script Name',
              'readOnly'    => false
            }]
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider image streamer' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:image_streamer_artifact_bundle).provider(:image_streamer)
  end

  context 'given the minimum parameters' do
    before(:each) do
      provider.exists?
    end
    it 'exists? should return false at first' do
      expect(provider.exists?).not_to be
    end

    it 'found should raise error at first' do
      expect { provider.found }.to raise_error(/No ArtifactBundle with the specified data were found on the Oneview Appliance/)
    end

    it 'should create a new artifact bundle' do
      expect(provider.create).to be
    end

    it 'should rename artifact bundle when new_name provided' do
      resource['data']['new_name'] = 'Artifact_Bundle_Renamed'
      provider.exists?
      expect(provider.create).to be
    end
  end

  context 'given the resource was created' do
    let(:resource) do
      Puppet::Type.type(:image_streamer_artifact_bundle).new(
        name: 'artifact-bundle-2',
        ensure: 'present',
        data:
            {
              'name' => 'Artifact_Bundle_Renamed'
            }
      )
    end
    before(:each) do
      provider.exists?
    end

    it 'exists? should find the artifact bundle' do
      expect(provider.exists?).to be
    end

    it 'should run destroy' do
      expect(provider.destroy).to be
    end
  end
end
