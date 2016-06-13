oneview_enclosure_group{'enclosure group':
    ensure  => 'found',
    data    => {
      name => 'my enclosure group',
      # new_name => 'dasdas',
      stackingMode => 'Enclosure',
      interconnectBayMappingCount => "8",
      type => 'EnclosureGroupV200',
      interconnectBayMappings =>
      [
        {
          interconnectBay => "1",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "2",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "3",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "4",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "5",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "6",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "7",
          logicalInterconnectGroupUri => nil
        },
        {
          interconnectBay => "8",
          logicalInterconnectGroupUri => nil
        }
      ]
    }
}
