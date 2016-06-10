oneview_fcoe_network{'fcoe':
    ensure => 'present',
    data   => {
      name                  => 'FCoE Network',
      new_name              => 'Test name', #This will be dropped at the first
      vlanId                => '100',
      connectionTemplateUri => 'nil',
      type                  => 'fcoe-network'
    }
}

oneview_fcoe_network{'fcoe update':
    ensure  => 'present',
    require => Oneview_fcoe_network['fcoe'],
    data    => {
      name                  => 'FCoE Network',
      new_name              => 'New FCoE Network Name',
      vlanId                => '100',
      connectionTemplateUri => 'nil',
      type                  => 'fcoe-network'
    }
}

oneview_fcoe_network{'fcoe update delete':
    ensure  => 'absent',
    require => Oneview_fcoe_network['fcoe update'],
    data    => {
      name                  => 'New FCoE Network Name',
      vlanId                => '100',
      connectionTemplateUri => 'nil',
      type                  => 'fcoe-network'
    }
}
