require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_fc_network).provider(:ruby)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_fc_network).new(
      name: 'fc',
      ensure: 'present',
      data:
          {
            'name'                    => 'OneViewSDK Test FC Network',
            'connectionTemplateUri'   => nil,
            'autoLoginRedistribution' => true,
            'fabricType'              => 'FabricAttach',
            'type' => 'fc-networkV2',
            'linkStabilityTime' => 30
          }
    )
  end

  # TODO: View the before :each method to reduce code repetition, specially for find_by calls
  # before(:each) do
  #   # @item = OneviewSDK::ServerProfileTemplate.new(@client, name: 'server_profile_template')
  #   test = OneviewSDK::FCNetwork.new(@client, resource['data'])
  #   puts test
  #   expect(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, name: resource['data']['name']).and_return(test)
  # end

  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fc_network).new(
        name: 'fc',
        ensure: 'present',
        data:
            {
              'name'                    => 'OneViewSDK Test FC Network',
              'connectionTemplateUri'   => nil,
              'autoLoginRedistribution' => true,
              'fabricType'              => 'FabricAttach',
              'type' => 'fc-networkV2',
              'linkStabilityTime' => 30
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fc_network).provider(:ruby)
    end

    it 'if nothing is found should return false' do
      expect(OneviewSDK::FCNetwork).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return true when resource exists' do
      test = [OneviewSDK::FCNetwork.new(@client, resource['data'])]
      expect(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, name: resource['data']['name']).and_return(test)
      expect(provider.exists?).to eq(true)
    end

    it 'runs through the create method' do
      test = OneviewSDK::FCNetwork.new(@client, resource['data'])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/fc-networks', { 'body' => resource['data'] }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/fc-networks/100')
      expect(provider.create).to eq(resource['data'])
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::FCNetwork.new(@client, resource['data'])
      expect(OneviewSDK::FCNetwork).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to eq({})
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fc_network).new(
        name: 'fc',
        ensure: 'present',
        data:
            {
              'name'                    => 'OneViewSDK Test FC Network',
              'new_name'                => 'OneViewSDK Test FC Network',
              'connectionTemplateUri'   => nil,
              'autoLoginRedistribution' => true,
              'fabricType'              => 'FabricAttach',
              'type' => 'fc-networkV2',
              'linkStabilityTime' => 30
            }
      )
    end
  end
end
