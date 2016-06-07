require 'spec_helper'
require 'oneview-sdk'

type_provider = Puppet::Type.type(:oneview_ethernet_network).provider(:ruby)

describe type_provider do

  # describe 'instances' do
  #   it 'should have an instance method' do
  #     expect(described_class).to respond_to :destroy
  #   end
  # end

end
