require 'spec_helper'

type_class = Puppet::Type.type(:oneview_ethernet_network)

def ethernet_config
  {
    name:                           'test_net',
    data:
      {     name:                   'Puppet Network',
            vlanId:                 '100',
            purpose:                'General',
            smartLink:              'false',
            privateNetwork:         'true',
            connectionTemplateUri:  'nil',
            type:                   'ethernet-networkV3',
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

 it 'should take name and data as parameters'do
  expect(ethernet_config).not_to include('name')
  expect(ethernet_config).not_to include('data')
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

# it 'should require a data hash' do
#   modified_config = ethernet_config
#   modified_config['data'] = ''
#   expect {
#       type_class.new(modified_config)
#   }.to raise_error(Puppet::ResourceError, "Inserted value for data is not valid")
# end
#
#   ethernet_config.keys.each do |key|
#     it "should require a value for #{key}" do
#       modified_config = ethernet_config
#       modified_config[key] = ''
#       expect {
#         type_class.new(modified_config)
#       }.to raise_error(Puppet::Error)
#     end
#   end
#
#   [
#     'name',
#     'purpose',
#     'type',
#   ].each do |property|
#     it "should require #{property} to be a string" do
#       expect(type_class).to require_string_for(property)
#     end
#   end

end
