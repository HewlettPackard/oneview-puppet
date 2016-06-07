oneview_ethernet_network{'job':
    ensure => 'present',
        data   => ''
}

# oneview_ethernet_network{'job1':
#     ensure => 'present',
#     require=> Oneview_ethernet_network['job'],
#     data   => {
#       name                  => 'Puppet Network',
#       new_name              => 'Edited Name',
#     }
# }
#
# oneview_ethernet_network{'job2':
#     ensure => 'present',
#     require=> Oneview_ethernet_network['job1'],
#     data   => {
#       name              => 'Edited Name',
#     }
# }
#
# oneview_ethernet_network{'net1':
#     ensure => 'present',
#     require=> Oneview_ethernet_network['job2'],
#     data   => {
#       name                  => 'Puppet Network',
#       vlanId                => '100',
#       purpose               => 'General',
#       smartLink             => 'false',
#       privateNetwork        => 'true',
#       connectionTemplateUri => 'nil',
#       type                  => 'ethernet-networkV3'
#     }
# }
#
# oneview_ethernet_network{'net2':
#     ensure  => 'present',
#     require => Oneview_ethernet_network['net1'],
#     data    => {
#       name                  => 'Puppet Network',
#       new_name              => 'Edited Name',
#       vlanId                => '1045',
#       purpose               => 'Management',
#       smartLink             => 'true',
#       privateNetwork        => 'false',
#       connectionTemplateUri => 'nil',
#       type                  => 'ethernet-networkV3'
#     }
# }
#
# oneview_ethernet_network{'net3':
#     ensure  => 'present',
#     require => Oneview_ethernet_network['net2'],
#     data    => {
#       name                  => 'Edited Name',
#       new_name              => 'Finishing',
#       vlanId                => '1045',
#       purpose               => 'General',
#       smartLink             => 'true',
#       privateNetwork        => 'false',
#       connectionTemplateUri => 'nil',
#       type                  => 'ethernet-networkV3'
#     }
# }
#
# oneview_ethernet_network{'net4':
#     ensure  => 'found',
#     require => Oneview_ethernet_network['net3'],
#     data    => {
#       name                  => 'Finishing'
#     }
# }
#
# oneview_ethernet_network{'net5':
#     ensure  => 'found',
#     require => Oneview_ethernet_network['net4'],
#     data    => {
#       vlanId                => '1045',
#     }
# }
#
# oneview_ethernet_network{'net6':
#     ensure  => 'found',
#     require => Oneview_ethernet_network['net5'],
#     data    => {
#       vlanId                => '1069',
#     }
# }
#
# oneview_ethernet_network{'net7':
#     ensure  => 'present',
#     require => Oneview_ethernet_network['net6'],
#     data    => {
#       name                  => 'Finishing',
#       new_name              => 'Finished',
#       vlanId                => '1045',
#       purpose               => 'General',
#       smartLink             => 'true',
#       privateNetwork        => 'false',
#       connectionTemplateUri => 'nil',
#       type                  => 'ethernet-networkV3'
#     }
# }
#
# oneview_ethernet_network{'net8':
#     ensure  => 'absent',
#     # require => Oneview_ethernet_network['net7'],
#     data    => {
#       name                  => 'Finished'
#     }
# }
