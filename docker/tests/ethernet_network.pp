oneview_ethernet_network{'net1':
    ensure  => 'absent',
    data    => {
      name                  => 'Puppet network',
      vlanId                => '1045',
      purpose               => 'General',
      smartLink             => 'false',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}