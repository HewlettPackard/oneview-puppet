ethernet_network{'net1':
    ensure => 'present',
    name => 'n1_104',
    vlanid => 'someId',
}

ethernet_network{'net2':
    ensure => 'present',
    name => 'n1_10dasd5',
    vlanid => 'someId',
}
