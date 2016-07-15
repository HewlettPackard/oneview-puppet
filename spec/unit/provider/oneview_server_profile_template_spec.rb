require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_server_profile_template).provider(:ruby)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_server_profile_template).new(
      name: 'spt',
      ensure: 'present',
      data:
          {
            'name'                  => 'SPT',
            'enclosureGroupUri'     => '/rest/',
            'serverHardwareTypeUri' => '/rest/'
          }
    )
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'set_new_profile',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/',
              'serverProfileName'     => 'SP'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    # it 'should not create a new server profile based on a template' do
    #   expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    #   expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
    #   expect(provider.exists?).to eq(true)
    #   expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    #
    #   test = OneviewSDK::ServerProfile.new(@client, name: 'SP', uri: '/rest/')
    #   expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:retrieve!).and_return(false)
    #   expect(provider.set_new_profile).to be(false)
    #
    # end

    # it 'should create a new server profile based on a template' do
    #   expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    #   expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
    #   expect(provider.exists?).to eq(true)
    #   expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    #   test = OneviewSDK::ServerProfile.new(@client, name: 'SP')
    #   allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:new_profile).with('SP')
    #
    #   expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post).with('/rest/server-profiles',
    # { 'body' => {"name"=>"SP", "type"=>"ServerProfileV5"} },
    #     test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
    #   allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/server-profiles/100')
    #   allow_any_instance_of(OneviewSDK::ServerProfile).to receive(:retrieve!).and_return(true)
    #   # allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    #
    #   expect(provider.set_new_profile).to be
    # end
  end

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
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should run found and return the resource does not exist' do
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect(provider.found).to eq(false)
    end

    it 'runs through the create method' do
      expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(false)
      expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(false)
      expect(provider.exists?).to eq(false)
      test = OneviewSDK::ServerProfileTemplate.new(@client, resource['data'])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/server-profile-templates', { 'body' => resource['data'] }, test.api_version)
        .and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/server-profile-templates/100')
      expect(provider.create).to eq(true)
    end

    it 'should get the server profile template information' do
      test = OneviewSDK::ServerProfileTemplate.new(@client, resource['data'])
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).and_return([test])
      expect(provider.get_server_profile_templates).to eq(true)
    end

    it 'should not get the server profile template information' do
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).and_return([])
      expect(provider.get_server_profile_templates).to eq(false)
    end

    it 'should return true if resource is found' do
      resource['data']['uri'] = '/rest/server-profile-templates/fake'
      test = OneviewSDK::ServerProfileTemplate.new(@client, name: resource['data']['name'])
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:update).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.found).to eq(true)
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::ServerProfileTemplate.new(@client, resource['data'])
      allow(OneviewSDK::ServerProfileTemplate).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.destroy).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'set_enclosure_group',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/',
              'enclosureGroup'        => 'EG'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    # it 'should set an enclosure group' do
    #   test = OneviewSDK::ServerProfileTemplate.new(@client, resource['data'])
    #   allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    #   allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
    #   expect(provider.exists?).to eq(true)
    #   eg = OneviewSDK::EnclosureGroup.new(@client, resource['data'])
    #   allow_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:find_by).
    #     with(anything, name: resource['data']['enclosureGroup']).and_return([eg])
    #   allow_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:retrieve!).and_return(true)
    #   allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:set_enclosure_group).and_return(true)
    #   expect(provider.set_enclosure_group).to eq(true)
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
        .to raise_error(Puppet::Error, 'Parameter data failed on Oneview_server_profile_template[spt]: Inserted value for data is \
        not valid')
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'set_server_hardware_type',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/',
              'serverHardwareType'    => 'SHT'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should set an enclosure group' do
      # test = OneviewSDK::ServerProfileTemplate.new(@client, resource['data'])
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
      expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
      expect(provider.exists?).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'set_connection',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/',
              'connections'           =>
                {
                  'name' => 'network',
                  'type' => 'EthernetNetwork'
                }
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should run through set connection' do
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
      expect(provider.exists?).to eq(true)
      test = OneviewSDK::EthernetNetwork.new(@client, name: 'network')
      allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:add_connection).with(network: test, connection_options: {})
        .and_return(true)
      expect(provider.set_connection).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'set_connection',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should not be able to set a connection' do
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
      expect(provider.exists?).to eq(true)
      expect(provider.set_connection).to be(false)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'get_available_hardware',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should return there is no available hardware' do
      # test = OneviewSDK::ServerProfileTemplate.new(@client, resource['data'])
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
      expect(provider.exists?).to eq(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:available_hardware).and_return([])
      expect(provider.get_available_hardware).to eq(nil)
    end
  end

  context 'given the creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'set_firmware_driver',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/',
              'firmwareDriver'        => 'firmwareDriver'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should set a firmware driver' do
      # test = OneviewSDK::ServerProfileTemplate.new(@client, name: resource['data']['name'])
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
      expect(provider.exists?).to eq(true)
      test = OneviewSDK::FirmwareDriver.new(@client, name: resource['data']['firmwareDriver'])
      allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:set_firmware_driver).and_return(test)
      expect(provider.set_firmware_driver).to eq(test)
    end
  end
end
