
oneview_storage_system{'storage_system_1':
    ensure  => 'present',
    data    => {
      name         => 'OneViewSDK Test Storage System',
      managedDomain => 'TestDomain',
      credentials => {
        ip_hostname  => '172.18.11.11',
        username     => 'dcs',
        password     => 'dcs',
      }
    }
}

oneview_storage_system{'storage_system_2':
    ensure  => 'present',
    require => Oneview_storage_system['storage_system_1'],
    data    => {
      name         => 'OneViewSDK Test Storage System',
      credentials => {
        ip_hostname  => '172.18.11.11',
      }
    }
}

oneview_storage_system{'storage_system_3':
    ensure  => 'found',
    require => Oneview_storage_system['storage_system_2'],
    data    => {
      credentials => {
        ip_hostname  => '172.18.11.11',
      }
    }
}

oneview_storage_system{'storage_system_4':
    ensure  => 'get_storage_pools',
    require => Oneview_storage_system['storage_system_3'],
    data    => {
      credentials => {
        ip_hostname  => '172.18.11.11',
      }
    }
}

oneview_storage_system{'storage_system_5':
    ensure  => 'get_managed_ports',
    require => Oneview_storage_system['storage_system_4'],
    data    => {
      credentials => {
        ip_hostname  => '172.18.11.11',
      }
    }
}

oneview_storage_system{'storage_system_6':
    ensure  => 'get_host_types',
    require => Oneview_storage_system['storage_system_5'],
    data    => {
      credentials => {
        ip_hostname  => '172.18.11.11',
      }
    }
}
oneview_storage_system{'storage_system_7':
    ensure  => 'absent',
    require => Oneview_storage_system['storage_system_6'],
    data    => {
      credentials => {
        ip_hostname  => '172.18.11.11',
      }
    }
}
