require 'spec_helper'

type_class = Puppet::Type.type(:oneview_ethernet_network)

def ethernet_config
  {
    name:                   'test_net'
  }
end

describe type_class do

  let :params do
  [
    :name,
  ]
  end

  it 'should accept a name' do
    expect(provider).to be_an_instance_of Puppet::Type::Cloudwatch_alarm::ProviderV2
  end

end
