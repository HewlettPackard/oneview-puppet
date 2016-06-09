require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_ethernet_network).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_ethernet_network).new(
      name: 'ethernet',
      ensure: 'present',
        data:
          {
            'name'                    =>'Puppet Network',
            'vlanId'                  => 100,
            'purpose'                 =>'General',
            'smartLink'               =>'false',
            'privateNetwork'          =>'true',
            'connectionTemplateUri'   =>'nil',
            'type'                    =>'ethernet-networkV3',
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_ethernet_network).provider(:ruby)
  end

  context 'given the min parameters' do

    it 'exists? shouldnt find a network' do
      expect(provider.exists?).to be_falsy
    end

    it 'should create a new network' do
      expect(provider.create).to be_truthy
    end

    it 'exists? should find a network' do
      expect(provider.exists?).to be_truthy
    end

    it 'should destroy the network' do
      expect(provider.destroy).to be_truthy
    end

  end


end
