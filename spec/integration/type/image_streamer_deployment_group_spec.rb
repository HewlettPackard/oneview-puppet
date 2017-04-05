require 'spec_helper'

type_class = Puppet::Type.type(:image_streamer_deployment_group)

def deployment_group_config
  {
    name: 'deployment1-group-1',
    ensure: 'found',
    data:
        {
          'name' => 'OSDS'
        }
  }
end

describe type_class do
  let(:params) { %i[name data provider] }

  let(:special_ensurables) { [:found] }

  it 'should accept special ensurables' do
    special_ensurables.each do |value|
      expect { described_class.new(name: 'Test', ensure: value, data: {}) }.to_not raise_error
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to include(param)
    end
  end

  it 'should require a name' do
    expect { type_class.new({}) }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = deployment_group_config
    modified_config[:data] = 5
    expect { type_class.new(modified_config) }.to raise_error(Puppet::Error, /Inserted value for data is not valid/)
  end
end
