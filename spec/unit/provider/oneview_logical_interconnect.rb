require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_logical_interconnect).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_logical_interconnect).new(
      name: 'Test Logical Interconnect',
    ensure: 'present',
        data:
          {
              'name'                    => 'Encl2-my enclosure logical interconnect group',
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_interconnect).provider(:ruby)
  end

  it 'should get the snmp configuration from the logical interconnect'
    expect(provider.get_snmp_configuration).to be
  end

  it 'should get the port monitor from the logical interconnect'
    expect(provider.get_port_monitor).to be
  end

  it 'should get the qos configuration from the logical interconnect'
    expect(provider.get_qos_aggregated_configuration).to be
  end

  end