require 'spec_helper'

type_class = Puppet::Type.type(:oneview_fc_network)

def fc_config
  {
    name:                           'test_fc',
    data:
      {
        name:                       'OneViewSDK Test FC Network',
        connectionTemplateUri:      nil,
        autoLoginRedistribution:    true,
        fabricType:                 'FabricAttach'
      }
  }
end

describe type_class do
  let :params do
    [
      :name,
      :data,
      :provider
    ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a name' do
    expect do
      type_class.new({})
    end.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = fc_config
    modified_config[:data] = ''
    expect do
      type_class.new(modified_config)
    end.to raise_error(/Inserted value for data is not valid/)
  end
end
