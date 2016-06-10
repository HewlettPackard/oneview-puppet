require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_fc_network).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_fc_network).new(
      name: 'fc',
      ensure: 'present',
      data:
          {
              'name'                    =>   'test',
              'connectionTemplateUri'   =>   'nil',
              'autoLoginRedistribution' =>   true,
              'fabricType'              =>   'FabricAttach',
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fc_network).provider(:ruby)
  end

  context 'given the min parameters' do

    describe 'exists?' do
      it 'should correctly show that network does not exist' do
        expect(provider.exists?).not_to be
      end
    end

    # describe 'found' do
    #   it 'should return that no network was found' do
    #     expect(provider.found).not_to be
    #   end
    # end

    describe 'create' do
      it 'should run create' do
        expect(provider.create).to be
      end
    end

    describe 'found' do
      it 'should return that no network was found' do
        expect(provider.found).to be
      end
    end

    describe 'exists?' do
      it 'should correctly show that network exists' do
        expect(provider.exists?).to be
      end
    end

    describe 'running destroy' do
      it 'should run destroy' do
        expect(provider.destroy).to be
      end
    end

  end

end
