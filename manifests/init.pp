class oneview {

        # # CONNECTION TO THE APPLIANCE
        # # **********************************************************************
        # # Login info for the OneView appliance
        $login_information = {
          appliance_adress =>  '<Your appliance IP here>',
          login =>  '<Your appliance\'s user here>',
          password =>  '<Your appliance\'s password here>'
        }
        # # Connecting to appliance
        connection_create($login_information)
        #
        # # ETHERNET NETWORK
        # # **********************************************************************
        # # Ethernet options (going to be the same for all CRUD operations)
        $ethernet_options = {
                  vlanId =>  '1201',
                  purpose =>  'General',
                  name =>  'OneViewSDK Test Vlan',
                  smartLink =>  'false',
                  privateNetwork =>  'false',
                  connectionTemplateUri => 'nil',
                  type =>  'ethernet-networkV3'
                }

        $attributes = {
                  name =>  'Puppet Network'
                }
        ethernet_network("create", $ethernet_options) # Creates ethernet network
        ethernet_network("find", $ethernet_options) # Finds ethernet network
        ethernet_network("update", $ethernet_options,$attributes) # Updates ethernet network
        ethernet_network("delete", $attributes) # Deletes ethernet network
}
