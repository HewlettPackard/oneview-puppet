oneview_logical_enclosure{'logical_enc1':
    ensure  => 'present',
    data    => {
      name                      =>  'Encl1',
    }
}

# oneview_logical_enclosure{'logical_enc1':
#     ensure  => 'get_script',
#     data    => {
#       name                      =>  'Encl1',
#     }
# }
#
# oneview_logical_enclosure{'logical_enc2':
#     ensure  => 'set_script',
#     data    => {
#       name                      =>  'Encl1',
#       script                    =>  'exemplo teste',
#     }
# }
#
# oneview_logical_enclosure{'logical_enc3':
#     ensure  => 'get_script',
#     data    => {
#       name                      =>  'Encl1',
#     }
# }
#
# oneview_logical_enclosure{'logical_enc4':
#     ensure  => 'dumped',
#     data    => {
#       name                      =>  'Encl1',
#       dump                      =>
#         {
#           errorCode => 'Mydump',
#           encrypt => false,
#           excludeApplianceDump => false
#         }
#     }
# }
#
# oneview_logical_enclosure{'logical_enc5':
#     ensure  => 'updated_from_group',
#     data    => {
#       name                      =>  'Encl1',
#     }
# }
