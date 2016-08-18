require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_fc_network).provider(:oneview_fc_network)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_fc_network).new(
      name: 'fc',
      ensure: 'present',
      data:
          {
            'name' => 'OneViewSDK Test FC Network',
            'connectionTemplateUri'   => nil,
            'autoLoginRedistribution' => true,
            'fabricType'              => 'FabricAttach'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider oneview_fc_network' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fc_network).provider(:oneview_fc_network)
  end

  context 'given the minimum parameters' do
    it 'exists? should return false at first' do
      expect(provider.exists?).not_to be
    end

    it 'found should return false at first' do
      expect(provider.found).not_to be
    end

    # it 'should not have a network to destroy' do
    #   expect(provider.destroy).not_to be
    # end

    it 'should create a new network' do
      expect(provider.create).to be
    end

    it 'exists? should find a network' do
      expect(provider.exists?).to be
    end

    # it 'found should return the matching network' do
    #   expect(provider.found).to be
    # end

    it 'should run destroy' do
      expect(provider.destroy).to be
    end
  end
end
