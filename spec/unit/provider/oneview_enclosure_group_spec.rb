require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_enclosure_group).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_enclosure_group).new(
      name: 'Enclosure Group',
      ensure: 'present',
        data:
          {
            'name'                         =>'Enclosure Group',
            'interconnectBayMappingCount'  => 8,
            'stackingMode'                 =>'Enclosure',
            'type'                         =>'EnclosureGroupV200',
            'interconnectBayMappings'      =>
            [
              {
                'interconnectBay' => "1",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "2",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "3",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "4",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "5",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "6",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "7",
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => "8",
                'logicalInterconnectGroupUri' => nil
              }
            ]
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure_group).provider(:ruby)
  end


  context 'given the minimum parameters' do

    it 'exists? should not find an enclosure group' do
      expect(provider.exists?).not_to be
    end

    it 'should create a new enclosure group' do
      expect(provider.create).to be
    end

    it 'exists? should find an enclosure group' do
      expect(provider.exists?).to be
    end

    it 'should return that a network was found' do
      expect(provider.found).to be
    end

    it 'should destroy the enclosure group' do
      expect(provider.destroy).to be
    end

  end

end
