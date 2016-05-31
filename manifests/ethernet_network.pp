# ethernet_network{'net1':
#     ensure => 'present',
#     attributes => {
#       name    => 'n1_104',
#       vlanid  => 'someid'
#     }
# }

ethernet_network{'net2':
    ensure => 'absent',
    attributes => {
      vlanId                => '1001',
      purpose               => 'General',
      name                  => 'Net 2das',
      smartLink             => 'false',
      privateNetwork        => 'false',
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}
