require 'spec_helper'

type_class = Puppet::Type.type(:oneview_fcoe_network)

def fcoe_config
  {
    ensure:                         'present',
    data:
      {
          name:                       'OneViewSDK Test FC Network',
          connectionTemplateUri:      'nil',
          autoLoginRedistribution:    'true',
          fabricType:                 'FabricAttach',
      },
  }
end

describe type_class do

  let :params do
  [
    :name,
    :data,
  ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should take ensure and data as parameters' do
   expect(fcoe_config).to include(:data)
   expect(fcoe_config).to include(:ensure)
  end

  it 'values should be strings' do
    fcoe_config.each do |key, value|
      expect(key).to be_a(Symbol)
      expect(value).not_to be_an(Integer)
    end
  end

  it 'should be a hash' do
    expect(fcoe_config).to be_a_kind_of(Hash)
  end

  it 'should raise error if different' do

  end

  it 'should require a name' do
    expect {
      type_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end


  # it 'should require a data hash' do
  #   modified_config = fc_config
  #   modified_config[:data] = ''
  #   resource_type = type_class.to_s.split('::')
  #   expect {
  #       type_class.new(modified_config)
  #   }.to raise_error(Puppet::Error, "Parameter data failed on" +
  #   " #{resource_type[2]}[#{modified_config[:name]}]: Invalid Data Hash")
  # end

end
