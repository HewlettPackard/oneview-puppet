oneview_enclosure_group{'Enclosure Group Create':
    ensure  => 'present',
    data    => {
      name => 'Enclosure Group',
      # new_name => 'dasdas',
      stackingMode => 'Enclosure',
      interconnectBayMappingCount => "8",
      type => 'EnclosureGroupV200',
      interconnectBayMappings =>
      [
        {
          interconnectBay => "1",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "2",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "3",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "4",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "5",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "6",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "7",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "8",
          logicalInterconnectGroupUri => 'nil'
        }
      ]
    }
}

oneview_enclosure_group{'Enclosure Group Found':
    require => Oneview_enclosure_group['Enclosure Group Create'],
    ensure  => 'found',
    data    => {
      name  => 'Enclosure Group',
    }
}

oneview_enclosure_group{'Enclosure Group Update':
    require => Oneview_enclosure_group['Enclosure Group Found'],
    ensure  => 'present',
    data    => {
      name  => 'Enclosure Group',
      new_name => 'New name'
    }
}

oneview_enclosure_group{'Enclosure Group Delete':
    # require => Oneview_enclosure_group['Enclosure Group Update'],
    ensure  => 'absent',
    data    => {
      name => 'New name'
    }
}
