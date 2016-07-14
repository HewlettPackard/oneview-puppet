require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_uplink_set).provider(:ruby)

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::UplinkSet

  let(:resource) do
    Puppet::Type.type(:oneview_uplink_set).new(
      name: 'uplink_set_1',
      ensure: 'found'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    # provider.exists?
  end
  # TODO: View the before :each method to reduce code repetition, specially for find_by calls
  # before(:each) do
  #   # @item = OneviewSDK::ServerProfileTemplate.new(@client, name: 'server_profile_template')
  #   test = OneviewSDK::UplinkSet.new(@client, resource['data'])
  #   puts test
  #   expect(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, name: resource['data']['name']).and_return(test)
  # end

  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ]
            },
        network: 'Puppet Test EthNetwork',
        logical_interconnect: 'Encl1-Test Oneview'
      )
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_uplink_set).provider(:ruby)
    end

    it 'should return false if resource does not exist' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return false if resource is not found' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect(provider.found).to eq(false)
    end

    it 'should return true if resource is found' do
      resource['data']['uri'] = '/rest/uplink-sets/fake'
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:update).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.found).to eq(true)
    end

    it 'runs through the create method' do
      data = { 'fcNetworkUris' => [], 'fcoeNetworkUris' => [], 'networkUris' => ['/rest/ethernet-networks/fake'],
               'portConfigInfos' => [], 'primaryPortLocation' => nil, 'type' => 'uplink-setV3',
               'logicalInterconnectUri' => '/rest/logical-interconnects/fake' }
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      network = OneviewSDK::EthernetNetwork.new(@client, name: 'Puppet Test EthNetwork', uri: '/rest/ethernet-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).and_return([network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/uplink-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/uplink-sets/fake')
      expect(provider.create).to eq(true)
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:update).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.destroy).to eq({})
    end
  end

  # TODO: Fix type test eventually
  # context 'given the minimum parameters' do
  #   let(:resource) do
  #     Puppet::Type.type(:oneview_uplink_set).new(
  #       name: 'uplink_set_1',
  #     ensure: 'found',
  #       data: 'Wrong Kind of Data ',
  #       network: 'Puppet Test EthNetwork',
  #       logical_interconnect: 'Encl1-Test Oneview'
  #     )
  #   end
  #
  #   it 'should fail if data is not a hash' do
  #     expect(Puppet::Type::Oneview_uplink_set::ProviderRuby).to raise_error
  #   end
  #
  # end

  context 'Run ensure with a different option than present' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'found',
        # data: {name ='Wrong Kind of Data '},
        network: 'Puppet Test EthNetwork',
        logical_interconnect: 'Encl1-Test Oneview'
      )
    end

    it 'Should return false when nothing exists' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end
  end

  context 'When using FC Network ' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ]
            },
        fc_network: 'Puppet Test FC_Network',
        logical_interconnect: 'Encl1-Test Oneview'
      )
    end

    it 'runs through the create method' do
      data = { 'fcNetworkUris' => ['/rest/fc-networks/fake'], 'fcoeNetworkUris' => [], 'networkUris' => [],
               'portConfigInfos' => [], 'primaryPortLocation' => nil, 'type' => 'uplink-setV3',
               'logicalInterconnectUri' => '/rest/logical-interconnects/fake' }
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      fc_network = OneviewSDK::FCNetwork.new(@client, name: 'Puppet Test FCNetwork', uri: '/rest/fc-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::FCNetwork).to receive(:find_by).and_return([fc_network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/uplink-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/uplink-sets/fake')
      expect(provider.create).to eq(true)
    end
  end

  context 'When using FCoE Network ' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ]
            },
        fcoe_network: 'Puppet Test FCoENetwork',
        logical_interconnect: 'Encl1-Test Oneview'
      )
    end

    it 'runs through the create method' do
      data = { 'fcNetworkUris' => [], 'fcoeNetworkUris' => ['/rest/fcoe-networks/fake'], 'networkUris' => [],
               'portConfigInfos' => [], 'primaryPortLocation' => nil, 'type' => 'uplink-setV3',
               'logicalInterconnectUri' => '/rest/logical-interconnects/fake' }
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      fcoe_network = OneviewSDK::FCoENetwork.new(@client, name: 'Puppet Test FCoENetwork', uri: '/rest/fcoe-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::FCoENetwork).to receive(:find_by).and_return([fcoe_network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/uplink-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/uplink-sets/fake')
      expect(provider.create).to eq(true)
    end
  end
end
