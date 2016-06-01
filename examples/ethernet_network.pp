ethernet_network{'net1':
    ensure => 'present',
    attributes => {
      vlanId                => '1001',
      purpose               => 'General',
      name                  => 'Puppet 1',
      smartLink             => 'true',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

ethernet_network{'net2':
    ensure => 'present',
    attributes => {
      vlanId                => '1050',
      purpose               => 'Management',
      name                  => 'Puppet 1',
      smartLink             => 'false',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

ethernet_network{'net3':
    ensure => 'absent',
    attributes => {
      vlanId                => '1075',
      purpose               => 'General',
      name                  => 'Puppet 1',
      smartLink             => 'false',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}
