oneview_fcoe_network{'fcoe':
    ensure => 'present',
    data   => {
      name                  => 'FCoE Net',
      new_name => 'ueheu',
      vlanId                => '100',
      connectionTemplateUri => 'nil',
      type                  => 'fcoe-network'
    }
}
