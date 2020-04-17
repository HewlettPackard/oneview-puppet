require 'spec_helper'

type_class = Puppet::Type.type(:oneview_hypervisor_manager)

def hm_config
  {
    name: 'test_hm',
    ensure: 'present'
    data:
      {
        name     => '172.18.13.11',
        username => 'dcs',
        password => 'dcs'
      }
  }
end

describe type_class, integration: true do
  let(:params) { %i[name data provider] }

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
    modified_config = hm_config
    modified_config[:data] = ''
    expect do
      type_class.new(modified_config)
    end.to raise_error(/Inserted value for data is not valid/)
  end
end
