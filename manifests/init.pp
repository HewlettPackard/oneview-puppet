class oneview (
  $action_list
  ) {

        # # Here we verify the expected resource, the action that will be performed and the options passed onto it
        # # **********************************************************************
        $action_list.each |$key, $value| {
          case $value['action'] {
            'connection_create': {connection_create($value['options'])}
            'ethernet_network_create': {ethernet_network("create", $value['options'])}
            'ethernet_network_find': {ethernet_network("find", $value['options'])}
            'ethernet_network_update': {ethernet_network("update", $value['options'], $value['attributes'])}
            'ethernet_network_delete': {ethernet_network("delete", $value['options'])}
            }
        }


/* DEPRECATED Code for reference on how to directly call the functions
        ethernet_network("create", $ethernet_options) # Creates ethernet network
        ethernet_network("find", $ethernet_options) # Finds ethernet network
        ethernet_network("update", $ethernet_options,$attributes) # Updates ethernet network
        ethernet_network("delete", $attributes) # Deletes ethernet network
*/
}
