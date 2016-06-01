ethernet_network{'net1':
    ensure => 'present',
    attributes => {
      vlanId                => 'asda',
      purpose               => 'General',
      name                  => 'Puppet 1',
      smartLink             => 'false',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

ethernet_network{'net2':
    ensure => 'present',
    attributes => {
      vlanId                => '1050',
      purpose               => 'General',
      name                  => 'Puppet 2',
      smartLink             => 'true',
      privateNetwork        => 'true',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

# ethernet_network{'net3':
#     ensure => 'absent',
#     attributes => {
#       vlanId                => '1075',
#       purpose               => 'General',
#       name                  => 'Puppet 1',
#       smartLink             => 'false',
#       privateNetwork        => 'false',
#       connectionTemplateUri => 'nil',
#       type                  => 'ethernet-networkV3'
#     }
# }
