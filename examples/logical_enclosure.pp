# oneview_logical_enclosure{'logical_enc0':
#     ensure  => 'present',
#     data    => {
#       name                      =>  'one_enclosure_le',
#       enclosureUris             =>  'rest/enclosures/09SGH100X6J1',
#       enclosureGroupUri         =>  '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#       firmwareBaselineUri       =>  'null',
#       forceInstallFirmware       =>  'false',
#     }
# }

oneview_logical_enclosure{'logical_enc1':
    ensure => 'get_script',
    data   => {
      name                      =>  'Encl1',
    }
}

oneview_logical_enclosure{'logical_enc2':
    ensure => 'set_script',
    data   => {
      name   =>  'Encl1',
      script =>  'This is a script example',
    }
}

oneview_logical_enclosure{'logical_enc3':
    ensure => 'get_script',
    data   => {
      name                      =>  'Encl1',
    }
}

oneview_logical_enclosure{'logical_enc4':
    ensure => 'updated_from_group',
    data   => {
      name                      =>  'Encl1',
    }
}

oneview_logical_enclosure{'logical_enc5':
    ensure => 'dumped',
    data   => {
      name =>  'Encl1',
      dump =>
        {
          errorCode            => 'Mydump',
          encrypt              => false,
          excludeApplianceDump => false
        }
    }
}
