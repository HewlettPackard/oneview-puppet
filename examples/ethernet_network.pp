
oneview_ethernet_network{'net1':
    ensure  => 'present',
    data    => {
      name                  => 'Puppet network',
      vlanId                => '1045',
      purpose               => 'General',
      smartLink             => 'true',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}
oneview_ethernet_network{'net2':
    ensure  => 'present',
    require => Oneview_ethernet_network['net1'],
    data    => {
      name                  => 'Puppet network',
      new_name              => 'Updated',
      vlanId                => '1045',
      purpose               => 'General',
      smartLink             => 'true',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

oneview_ethernet_network{'net3':
    ensure  => 'found',
    require => Oneview_ethernet_network['net2'],
    data    => {
      name                  => 'Updated'
    }
}

oneview_ethernet_network{'net4':
    ensure  => 'found',
    require => Oneview_ethernet_network['net3'],
    data    => {
      vlanId                => '1',
    }
}


oneview_ethernet_network{'net5':
    ensure  => 'absent',
    require => Oneview_ethernet_network['net4'],
    data    => {
      name                  => 'Updated'
    }
}
