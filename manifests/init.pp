class oneview-puppet {

        # # CONNECTION TO THE APPLIANCE
        # # **********************************************************************
        # # Login info for the OneView appliance
        $login_information = {
          appliance_adress =>  'https://172.16.101.19',
          login =>  'Administrator',
          password =>  'rainforest'
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
        # # Creating ethernet
        # ethernet_network_create($ethernet_options)
        # # Finding ethernet
        # ethernet_network_find($ethernet_options)
        # # Updating ethernet
        $attributes = {
                  name =>  'Puppet Network'
                }
        # ethernet_network_update($ethernet_options, $attributes)
        # # Deleting ethernet
        # ethernet_network_delete($attributes)
        #
        ethernet_network("create", $ethernet_options)
}
