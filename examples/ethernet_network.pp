oneview_ethernet_network{'net1':
    ensure => 'present',
    data => {
      vlanId                => '100',
      purpose               => 'General',
      name                  => 'Puppet 1',
      smartLink             => 'false',
      privateNetwork        => 'true',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

oneview_ethernet_network{'net2':
    ensure => 'present',
    data => {
      vlanId                => '1045',
      purpose               => 'Management',
      name                  => 'Puppet 1',
      smartLink             => 'false',
      privateNetwork        => 'true',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

oneview_ethernet_network{'net3':
    ensure => 'absent',
    data => {
      vlanId                => '1050',
      purpose               => 'General',
      name                  => 'Puppet 1',
      smartLink             => 'true',
      privateNetwork        => 'true',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}
