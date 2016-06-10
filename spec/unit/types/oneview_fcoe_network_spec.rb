require 'spec_helper'

type_class = Puppet::Type.type(:oneview_fcoe_network)

def fcoe_config
  {
    name:                           'test_net',
    data:
      {     name:                   'Puppet Network',
            vlanId:                 '100',
            connectionTemplateUri:  'nil',
            type:                   'fcoe-networkV3',
      },
  }
end

describe type_class do

  let :params do
  [
    :name,
    :data,
    :provider,
  ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a name' do
    expect {
      type_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

end
