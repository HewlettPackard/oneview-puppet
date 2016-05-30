class oneview (
  $action_list
  ) {

/*
create_resources ($action_list)
notify {"\n${key} and ${value}\n":}
*/

        # # CONNECTION TO THE APPLIANCE
        # # **********************************************************************
/* DEPRECATED CODE FOR LOGIN INFO
        # # Login info for the OneView appliance
        $login_information = {
          appliance_adress =>  'https://172.16.103.21',
          login =>  'Administrator',
          password =>  'rainforest'
        }
*/
        # # Connecting to appliance
        $action_list.each |$key, $value| {
          case $value['action'] {
            'connection_create': {connection_create($value['options'])}
            'ethernet_network_create': {ethernet_network("create", $value['options'])}
            'ethernet_network_find': {ethernet_network("find", $value['options'])}
            'ethernet_network_update': {ethernet_network("update", $value['options'], $value['attributes'])}
            'ethernet_network_delete': {ethernet_network("delete", $value['options'])}
            }
        }


/*
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
*/
}
