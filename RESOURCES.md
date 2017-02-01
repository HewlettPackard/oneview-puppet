# Resources for the Puppet Module for HPE OneView

1. [Oneview_connection_template](#oneview_connection_template)
2. [Oneview_datacenter](#oneview_datacenter)
3. [Oneview_enclosure_group](#oneview_enclosure_group)
4. [Oneview_enclosure](#oneview_enclosure)
5. [Oneview_ethernet_network](#oneview_ethernet_network)
6. [Oneview_fabric](#oneview_fabric)
7. [Oneview_fc_network](#oneview_fc_network)
8. [Oneview_fcoe_network](#oneview_fcoe_network)
9. [Oneview_firmware_bundle](#oneview_firmware_bundle)
10. [Oneview_firmware_driver](#oneview_firmware_driver)
11. [Oneview_interconnect](#oneview_interconnect)
12. [Oneview_logical_downlink](#oneview_logical_downlink)
13. [Oneview_logical_enclosure](#oneview_logical_enclosure)
14. [Oneview_logical_interconnect_group](#oneview_logical_interconnect_group)
15. [Oneview_logical_interconnect](#oneview_logical_interconnect)
16. [Oneview_logical_switch](#oneview_logical_switch)
17. [Oneview_logical_switch_group](#oneview_logical_switch_group)
18. [Oneview_managed_san](#oneview_managed_san)
19. [Oneview_network_set](#oneview_network_set)
20. [Oneview_power_device](#oneview_power_device)
21. [Oneview_rack](#oneview_rack)
22. [Oneview_san_manager](#oneview_san_manager)
23. [Oneview_server_hardware](#oneview_server_hardware)
24. [Oneview_server_hardware_type](#oneview_server_hardware_type)
25. [Oneview_server_profile_template](#oneview_server_profile_template)
26. [Oneview_server_profile](#oneview_server_profile)
27. [Oneview_storage_pool](#oneview_storage_pool)
28. [Oneview_storage_system](#oneview_storage_system)
29. [Oneview_switch](#oneview_switch)
30. [Oneview_unmanaged_device](#oneview_unmanaged_device)
31. [Oneview_uplink_set](#oneview_uplink_set)
32. [Oneview_volume](#oneview_volume)
33. [Oneview_volume_attachment](#oneview_volume_attachment)
34. [Oneview_volume_template](#oneview_volume_template)

#### oneview_connection_template

This resource provides the following ensurable methods for managing Connection Templates on the HPE OneView appliance:

* `present` - For this resource, present is only able to update the connection template. Creation is managed by another OneView resource.
* `found` - Searches for `oneview_connection_template` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_default_connection_template` - Gets the default network connection template. This is the default connection template used for construction of networks. Its value is copied when a new connection template is made. A `data` is not required to be informed for this ensurable.

:exclamation: **NOTE:**  This resource does NOT accept a `present`/`absent` state as it is created/removed through other HPE OneView resources.

Example file: [connection_template.pp](examples/connection_template.pp)

#### oneview_datacenter

This resource provides the following ensurable methods for managing Datacenters on the HPE OneView appliance:

* `present` - Adds or updates a data center resource based upon the attributes specified within `data`.
* `absent` - Deletes the set of datacenters according to the specified parameters within `data`.
* `found` - Searches for `oneview_datacenter` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_visual_content` - Gets a list of visual content objects describing each rack within the data center specified in `data`.

Example file: [datacenter.pp](examples/datacenter.pp)

#### oneview_drive_enclosure

This resource provides the following ensurable methods for managing Drive Enclosures on the HPE OneView appliance:

* `present` - Performs a specific `patch` operation for the given drive enclosure using the attributes in `data`.
* `found` - Searches for `oneview_drive_enclosure` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `set_refresh_state` - Refreshes the specified drive enclosure.

:warning: This resource type is only supported by the **Synergy** hardware variant.

Example file: [drive_enclosure.pp](examples/drive_enclosure.pp)

#### oneview_enclosure_group

This resource provides the following ensurable methods for managing Enclosure Groups on the HPE OneView appliance:

* `present` - Creates or updates an enclosure group. An interconnect bay mapping must be provided for each interconnect bay in the enclosure. For this release, the same logical interconnect group must be provided for each interconnect bay mapping.
* `absent` - Deletes an enclosure group.
* `found` - Searches for an `oneview_enclosure_group` resource on the appliance (with or without specific filters) and prints the information to the standard output.
* `set_script` - Updates the configuration script of the enclosure group with the specified.
* `get_script` - Gets the configuration script of the enclosure group resource specified in `data` and prints it to the standard output.

Example file: [enclosure_group.pp](examples/enclosure_group.pp)

#### oneview_enclosure

This resource provides the following ensurable methods for managing Enclosures on the HPE OneView appliance:

* `present` - Takes information about an enclosure (e.g., IP address, username, password) inside a `data` hash and uses it to claim/configure the enclosure and add/update its components on the appliance.
* `absent` - Removes and unconfigures the specified enclosure from the appliance.
* `found` - Searches for `oneview_enclosure` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `set_environmental_configuration` - Sets the calibrated max power of an unmanaged or unsupported enclosure.
* `set_configuration` - Reapplies the appliance's configuration on the specified enclosure.
* `set_refresh_state` - Refreshes the specified enclosure along with all of its components, including interconnects and servers.
* `get_script` - Retrieves the script from within an enclosure group specified in `data` and prints the script to the standard output. This requires a script to be set within the enclosure to work.
* `get_single_sign_on` - Builds the SSO (Single Sign-On) URL parameters for the specified enclosure. This allows the user to log in to the enclosure without providing credentials. This API is currently only supported by C7000 enclosures.
* `get_utilization` - Retrieves historical utilization data for the specified enclosure, metrics, and time span. Accepts a tag `utilization_parameters` within `data` with the desired query parameters.
* `get_environmental_configuration` - Gets the settings that describe the environmental configuration (supported feature set, calibrated minimum and maximum power, location and dimensions, etc.) of the specified enclosure resource.

Example file: [enclosure.pp](examples/enclosure.pp)

#### oneview_ethernet_network

This resource provides the following ensurable methods for managing Ethernet Networks on the HPE OneView appliance:

* `present` - Creates or updates a single Ethernet network, or, given a `vlanIdRange` inside `data`, creates Ethernet networks in bulk.
* `absent` - Deletes an Ethernet network. Any deployed connections that are using the network will be placed into a **Failed** state.
* `found` - Searches for `oneview_ethernet_network` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_associated_profiles` - Gets the profiles that are using a specified Ethernet network.
* `get_associated_uplink_groups` - Gets the uplink sets that are using a specified Ethernet network.
* `reset_default_bandwidth` - Retrieves de default connection template bandwidth, compares it to the current network's connection template and updates it if needed.

Example file: [ethernet_network.pp](examples/ethernet_network.pp)

#### oneview_fabric

This resource provides the following ensurable methods for managing fabrics on the HPE OneView appliance:

* `found` - Searches for `oneview_fabric` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_reserved_vlan_range` - Gets the reserved vlan ID range for the fabric.
* `set_reserved_vlan_range` - Updates the reserved vlan ID range for the fabric.

:exclamation: **NOTE:**  This resource does NOT accept a `present`/`absent` state as it is created/removed through other HPE OneView resources.

Example file: [fabric.pp](examples/fabric.pp)

#### oneview_fc_network

This resource provides the following ensurable methods for managing Fibre Channel networks on the HPE OneView appliance:

* `present` - Creates or updates a Fibre Channel network.
* `absent` - Deletes a Fibre Channel network. Any deployed connections that are using the network are placed in the **Failed** state.
* `found` - Searches for `oneview_fc_network` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.

Example file: [fc_network.pp](examples/fc_network.pp)

#### oneview_fcoe_network

This resource provides the following ensurable methods for managing FCoE networks on the HPE OneView appliance:

* `present` - Creates or updates an FCoE network.
* `absent` - Deletes an FCoE network.
* `found` - Searches for `oneview_fcoe_network` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.

Example file: [fcoe_network.pp](examples/fcoe_network.pp)

#### oneview_firmware_bundle

This resource provides the following ensurable methods for uploading firmware SPP (Service Pack for ProLiant) files or hotfixes to the HPE OneView appliance:

* `present` - Uploads an SPP ISO image file or a hotfix file to the HPE OneView appliance. It supports the upload of one hotfix at a time into the system. The `firmware_bundle_path` tag must be specified within the `data` hash containing the path to the desired SPP or hotfix file.

:exclamation: **NOTE:** This resource does not have `absent` or `found` ensurable methods; it is only able to upload the SPPs/Hotfixes to the HPE OneView appliance by using the `present` ensurable.

Example file: [firmware_bundle.pp](examples/firmware_bundle.pp)

#### oneview_firmware_driver

The firmware driver resource manager provides the following ensurable methods managing the firmwares uploaded to the HPE OneView appliance:

* `present` - Creates a custom SPP (Service Pack for Proliant) from an existing SPP and one or more hotfixes that have already been added to the system.
* `absent` - Deletes the specified firmware baseline resource.
* `found` - Searches for `oneview_firmware_driver` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.

Example file: [firmware_driver.pp](examples/firmware_driver.pp)

#### oneview_interconnect

This resource provides the following ensurable methods for managing interconnects on the HPE OneView appliance:

* `present` - Performs a specific `patch` operation for the given interconnect. There is a limited set of interconnect properties that may be changed, and these are: powerState, uidState, deviceResetState. If the interconnect supports the operation, the operation is performed.
* `found` - Searches for `oneview_interconnect` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_statistics` - Gets the statistics from an interconnect.
* `get_name_servers` - Gets the named servers for an interconnect.
* `get_types` - Gets a collection of all the interconnect types based on the specified parameters.
* `get_link_topologies` - Gets a paginated collection of all the interconnect link topologies based on the specified parameters. Filters can be used to control the number of interconnect link topologies that are returned. With no filters specified, the API returns all interconnect link toplogies.
* `update_ports` - Updates the specified interconnect ports.
* `reset_port_protection` - Triggers a reset of port protection for an interconnect.

:exclamation: **NOTE:** This resource does not have an `absent` ensurable, and the `present` can only be used to perform patch operations. The creation/deletion of these resources is managed by other resources.

Example file: [interconnect.pp](examples/interconnect.pp)

#### oneview_logical_downlink

This resource provides the following ensurable methods for managing logical downlinks on the HPE OneView appliance:

* `found` - Searches for `oneview_logical_downlink` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_without_ethernet` - Gets a specified logical downlink excluding any existing Ethernet networks.

:exclamation: **NOTE:** This resource does not have a `present` and `absent` ensurable. The creation/deletion of these resources is managed by other resources.

Example file: [logical_downlink.pp](examples/logical_downlink.pp)

#### oneview_logical_enclosure

This resource provides the following ensurable methods for managing one or more enclosures that are linked or stacked with stacking links on the HPE OneView appliance:

* `present` - Takes information about a logical enclosure (e.g., name, enclosure group uri, list of enclosures) and uses it to create or update the logical enclosure, create logical interconnects, and put enclosures and their components in the Configured state.
* `absent` - Deletes the logical enclosure, logical interconnects, and puts all enclosures and their components to the Monitored state.
* `found` - Searches for `oneview_logical_enclosure` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_script` - Gets the configuration script of the specified logical enclosure.
* `set_script` - Updates the configuration script of the specified logical enclosure and on all enclosures in the specified logical enclosure.
* `updated_from_group` - Makes a logical enclosure consistent with the enclosure group when the logical enclosure is in the Inconsistent state.
* `generate_support_dump` - Generates a support dump for the specified logical enclosure. A logical enclosure support dump includes content for logical interconnects associated with that logical enclosure. By default, it also contains appliance support dump content.

Example file: [logical_enclosure.pp](examples/logical_enclosure.pp)

#### oneview_logical_interconnect_group

This resource provides the following ensurable methods for managing  logical interconnect groups on the HPE OneView appliance:

* `present` - Creates or updates a logical interconnect group.
* `absent` - Deletes a logical interconnect group.
* `found` - Searches for `oneview_logical_interconnect_group` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_default_settings` - Gets the default interconnect settings for a logical interconnect group.
* `get_settings` - Gets the interconnect settings for a logical interconnect group.

Example file: [logical_interconnect_group.pp](examples/logical_interconnect_group.pp)

#### oneview_logical_interconnect

This resource provides the following ensurable methods for managing logical interconnects on the HPE OneView appliance:

* `present` - Updates the specified Logical Interconnect. :exclamation: **NOTE:** Creation is managed by other resources.
* `found` - Searches for `oneview_logical_interconnect` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_telemetry_configuration` - Gets the telemetry configuration of a logical interconnect.
* `get_snmp_configuration` - Gets the SNMP configuration for a logical interconnect.
* `get_port_monitor` - Gets the port monitor configuration of a logical interconnect.
* `get_firmware` -Gets the installed firmware for a logical interconnect.
* `get_internal_vlans` - Gets the internal VLAN IDs for the provisioned networks on a logical interconnect.
* `get_qos_aggregated_configuration` - Gets the QoS aggregated configuration for the logical interconnect.
* `get_ethernet_settings` - Gets the Ethernet interconnect settings for the logical interconnect.
* `set_configuration` - Asynchronously applies or re-applies the logical interconnect configuration to all managed interconnects.
* `set_compliance` - Gets the configuration script of the specified logical enclosure.
* `set_telemetry_configuration` - Updates the telemetry configuration of a logical interconnect. Changes to the telemetry configuration are asynchronously applied to all managed interconnects.
* `set_qos_aggregated_configuration` - Updates the QoS aggregated configuration for the logical interconnect.
* `set_snmp_configuration` - Updates the SNMP configuration of a logical interconnect. Changes to the SNMP configuration are asynchronously applied to all managed interconnects.
* `set_port_monitor` - Updates the port monitor configuration of a logical interconnect.
* `set_firmware` - Installs firmware to a logical interconnect. The three operations that are supported for the firmware update are Stage (uploads firmware to the interconnect), Activate (installs firmware on the interconnect) and Update (which does a Stage and Activate, sequentially).
* `set_internal_networks` - Updates internal networks on the logical interconnect.
* `set_ethernet_settings` - Updates the Ethernet interconnect settings for the logical interconnect.

:exclamation: **NOTE:** This resource does not have an `absent` ensurable. The deletion of these resources is managed by other resources.

Example file: [logical_interconnect.pp](examples/logical_interconnect.pp)

#### oneview_logical_switch

This resource provides the following ensurable methods for managing logical switches on the HPE OneView appliance:

* `present` - Creates a logical switch or updates its name.
* `absent` - Deletes a logical switch.
* `found` - Searches for `oneview_logical_switch` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `refresh` - Reclaims the top-of-rack switches in a logical switch.
* `update_credentials` - **DEPRECATED** This method will be removed on upcoming releases.
* `get_internal_link_sets` - Gets a paginated collection of all internal-link-sets. Filters can be used to control the number of internal link sets that are returned. With no filters specified, the API returns all internal link sets.

:exclamation: **NOTE:** The switches and their credentials must follow the declaration seen in the example file. The update via `present` ensurable is only valid for the Logical Switch name. To update its credentials, the `update_credentials` ensurable must be used.

:warning: This resource type is only supported by the **C7000** hardware variant.

Example file: [logical_switch.pp](examples/logical_switch.pp)

#### oneview_logical_switch_group

This resource provides the following ensurable methods for managing logical switch groups on the HPE OneView appliance:

* `present` - Creates or updates a logical switch group.
* `absent` - Deletes a logical switch group.
* `found` - Searches for `oneview_logical_switch_group` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.

:exclamation: **NOTE:** The declaration of logical switch groups must follow the one seen in the example file.

:warning: This resource type is only supported by the **C7000** hardware variant.

Example file: [logical_switch_group.pp](examples/logical_switch_group.pp)

#### oneview_managed_san

This resource provides the following ensurable methods for managing SANs on the HPE OneView appliance:

* `present` - Updates a Managed SAN. :exclamation: **NOTE:** Creation is managed by other resources.
* `found` - Searches for `oneview_managed_san` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_zoning_report` - Creates and retrieves an unexpected zoning report task for a SAN.
* `get_endpoints` - Retrieves a list of endpoints in a specified SAN.
* `set_refresh_state` - Sets the refresh state for a specified SAN.

**NOTE 1:** A SAN represents a physical or logical fibre channel SAN or a Flat SAN (i.e. direct wire attach).

**NOTE 2:** This resource does not have an `absent` ensurable. The deletion of these resources is managed by other resources.

Example file: [managed_san.pp](examples/managed_san.pp)

#### oneview_network_set

This resource provides the following ensurable methods for managing network sets on the HPE OneView appliance:

* `present` - Creates or updates network set.
* `absent` - Deletes a network set. Any connections that reference the network set and are currently deployed will be placed into a **Failed** state.
* `found` - Searches for `oneview_network_set` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_without_ethernet` - Gets a list of network sets, excluding Ethernet networks, based on optional sorting and filtering, and constrained by start and count parameters.

Example file: [managed_san.pp](examples/managed_san.pp)

#### oneview_power_device

This resource provides the following ensurable methods for managing Power delivery devices on the HPE OneView appliance:

* `present` - Adds or updates a power delivery device resource based upon the specified attributes.
* `absent` - Deletes the set of power-devices according to the specified parameters.
* `found` - Searches for `oneview_power_device` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `discover` - Add an HPE iPDU and bring all components under management by discovery of its management module.
* `set_refresh_state` - Refreshes a given intelligent power delivery device.
* `set_power_state` - Sets the power state of the specified power delivery device. The device must be an HPE Intelligent Outlet.
* `set_uid_state` - Sets the unit identification (UID) light state of the specified power delivery device. The device must be an HPE iPDU component with a locator light (HPE Intelligent Load Segment, HPE AC Module, HPE Intelligent Outlet Bar, or HPE Intelligent Outlet).
* `get_uid_state` - Retrieves the unit identification (UID) state (on, off, unknown) of the specified power outlet or extension bar resource. The device must be an HPE iPDU component with a locator light (HPE Intelligent Load Segment, HPE AC Module, HPE Intelligent Outlet Bar, or HPE Intelligent Outlet).
* `get_utilization` - Retrieves historical utilization data for the specified metrics and time span. The device must be a component of an HPE iPDU.


Example file: [power_device.pp](examples/power_device.pp)

#### oneview_rack

This resource provides the following ensurable methods for managing racks on the HPE OneView appliance:

* `present` - Adds or updates a rack resource based upon the specified attributes.
* `absent` - Deletes the set of racks according to the specified parameters.
* `found` - Searches for `oneview_rack` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_device_topology` - Retrieves the topology information for the specified rack resource.
* `add_rack_resource` - Adds the specified resource to the rack.
* `remove_rack_resource` - Removes specified resources from the rack.


Example file: [rack.pp](examples/rack.pp)

#### oneview_san_manager

This resource provides the following ensurable methods for managing SAN resource managers on the HPE OneView appliance:

* `present` - Adds or updates a registered SAN Manager.
* `absent` - Removes a registered SAN Manager.
* `found` - Searches for `oneview_rack` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.


Example file: [san_manager.pp](examples/san_manager.pp)

#### oneview_server_hardware

This resource provides the following ensurable methods for managing server hardwares on the HPE OneView appliance:

* `present` - Adds a rack mount server for management by the appliance.
* `absent` - Removes the specified rack-server.
* `found` - Searches for `oneview_server_hardware` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_bios` - Gets the list of BIOS/UEFI values currently set on the physical server.
* `get_ilo_sso_url` - Retrieves the URL to launch a Single Sign-On (SSO) session for the iLO web interface. If the server hardware is unsupported, the resulting URL will not use SSO and the iLO web interface will prompt for credentials. This is not supported on G7/iLO3 or earlier servers.
* `get_java_remote_sso_url` - Generates a Single Sign-On (SSO) session for the iLO Java Applet console and returns the URL to launch it. If the server hardware is unmanaged or unsupported, the resulting URL will not use SSO and the iLO Java Applet will prompt for credentials. This is not supported on G7/iLO3 or earlier servers.
* `get_remote_console_url` - Generates a Single Sign-On (SSO) session for the iLO Integrated Remote Console Application (IRC) and returns the URL to launch it. If the server hardware is unmanaged or unsupported, the resulting URL will not use SSO and the IRC application will prompt for credentials. Use of this URL requires a previous installation of the iLO IRC and is supported only on Windows clients.
* `get_environmental_configuration` - Gets the settings that describe the environmental configuration (supported feature set, calibrated minimum and maximum power, location and dimensions, etc.) of the server hardware resource.
* `get_utilization` - Retrieves historical utilization data for the specified resource, metrics, and time span.
* `update_ilo_firmware` - Updates the iLO firmware on a physical server to a minimum ILO firmware version required by OneView to manage the server.
* `set_power_state` - Requests a power operation to change the power state of the physical server.
* `set_refresh_state` - Refreshes the server hardware to fix configuration issues.


Example file: [server_hardware.pp](examples/server_hardware.pp)

#### oneview_server_hardware_type

This resource provides the following ensurable methods for managing server hardware types on the HPE OneView appliance:

* `present` - Updates one or more attributes for a server hardware type resource.
* `absent` - Removes the specified server hardware type.
* `found` - Searches for `oneview_server_hardware_type` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.

:exclamation: **NOTE:** The creation of this resource is managed by the HPE OneView itself when creating a server hardware. This provider can only update existing types and remove unused ones.

Example file: [server_hardware_type.pp](examples/server_hardware_type.pp)

#### oneview_server_profile_template

This resource provides the following ensurable methods for managing server profile templates on the HPE OneView appliance:

* `present` - Creates or updates a server profile template using the information provided.
* `absent` - Deletes a server profile template object from the appliance based on its profile template UUID.
* `found` - Searches for `oneview_server_profile_template` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `set_new_profile` - Creates a new server profile based on the current template.
* `get_transformation` - Transforms an existing profile template by supplying a new server hardware type and/or enclosure group. A profile template will be returned with a new configuration based on the capabilities of the supplied server hardware type and/or enclosure group. All configured connections will have their port assignment set to `Auto`.


Example file: [server_profile_template.pp](examples/server_profile_template.pp)

#### oneview_server_profile

This resource provides the following ensurable methods for managing server profiles on the HPE OneView appliance:

* `present` - Creates or updates a server profile using the information provided.
* `absent` - Deletes all Server Profile objects from the appliance that match the provided filter.
* `found` - Searches for `oneview_server_profile` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `update_from_template` - Updates the server profile from the server profile template.
* `get_available_networks` - Retrieves the list of Ethernet networks, Fibre Channel, networks and network sets that are available to a server profile along with their respective ports.
* `get_available_servers` - Retrieves the list of servers available to a server profile.
* `get_available_storage_systems` - Retrieves the list of storage systems and their associated volumes that are available to the server profile based on the given server hardware type and enclosure group.
* `get_available_storage_system` - Retrieves a specific storage system and its associated volumes that are available to the server profile based on the given server hardware type and enclosure group.
* `get_available_targets` - Retrieves a list of target servers and empty device bays that are available for assignment to the server profile.
* `get_profile_ports` - Retrieves the port model associated with a server or server hardware type and enclosure group.
* `get_compliance_preview` - Gets the preview of manual and automatic updates required to make the server profile consistent with its template.
* `get_messages` - Retrieves the error or status messages associated with the specified profile.
* `get_transformation` - Transforms an existing profile by supplying a new server hardware type and/or enclosure group. A profile will be returned with a new configuration based on the capabilities of the supplied server hardware type and/or enclosure group.
* `get_sas_logical_jbods` - Gets a paginated collection of SAS logical JBODs based on optional sorting and filtering.
* `get_sas_logical_jbod_drives` - Returns the list of drives allocated to the specified SAS logical JBOD.
* `get_sas_logical_jbod_attachments` - Gets a paginated collection of SAS logical JBOD attachments based on optional sorting and filtering.


Example file: [server_profile.pp](examples/server_profile.pp)

#### oneview_storage_pool

This resource provides the following ensurable methods for managing storage pools on the HPE OneView appliance:

* `present` - Adds storage pool for management by the appliance. If the storage pool is already added but with different attributes to the provided ones, it is removed and then added with the new information.
* `absent` - Removes an imported storage pool from OneView.
* `found` - Searches for `oneview_storage_pool` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.


Example file: [storage_pool.pp](examples/storage_pool.pp)

#### oneview_storage_system

This resource provides the following ensurable methods for managing storage systems on the HPE OneView appliance:

* `present` - Adds or updates a storage system for management by the appliance.
* `absent` - Removes the storage system from OneView.
* `found` - Searches for `oneview_storage_system` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_storage_pools` - Gets a list of storage pools belonging to the specified storage system.
* `get_managed_ports` - Gets all managed target ports for the specified storage system.
* `get_host_types` - Gets the list of supported host types.


Example file: [storage_system.pp](examples/storage_system.pp)

#### oneview_switch

This resource provides the following ensurable methods for managing Top-of-rack switches on the HPE OneView appliance:

* `absent` - Deletes a migrated switch.
* `found` - Searches for `oneview_switch` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_type` - Either gets a paginated collection of all the switch types or, if a switch type is specified, gets that specific switch type.
* `get_statistics` - Gets statistics for a switch, and accepts the port and subport as filters to narrow the list of statistics to show.
* `get_environmental_configuration` - Gets the environmental configuration for a switch.
* `set_scope_uris` - Performs a patch operation on the switch for the scopeUris property.

:exclamation: **NOTE:** The `present` ensurable is unavailable for this resource. Creation of this resource is managed by another resource on HPE OneView.
:warning: For the `Synergy` hardware variant, the only valid ensure method is `get_type`.

Example file: [switch.pp](examples/switch.pp)

#### oneview_unmanaged_device

This resource provides the following ensurable methods for describing devices which cannot be managed by the HPE OneView appliance:

* `present` - Adds or updates an unmanaged device resource based upon the specified attributes.
* `absent` - Deletes the set of unmanaged-devices according to the specified parameters.
* `found` - Searches for `oneview_unmanaged_device` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_environmental_configuration` - Returns a description of the environmental configuration (supported feature set, calibrated minimum and maximum power, location and dimensions, etc.) of the specified resource.

:exclamation: **NOTE:** An unmanaged device is used to manually describe any device, such as a server, enclosure, storage array, networking switch, tape drive, or display that consumes space in a rack or consumes power but cannot otherwise be managed by the appliance.

Example file: [unmanaged_device.pp](examples/unmanaged_device.pp)

#### oneview_uplink_set

This resource provides the following ensurable methods for managing uplink sets on the HPE OneView appliance:

* `present` - Creates or updates an uplink set.
* `absent` - Deletes an uplink set. If the uplink set was carrying a Fibre Channel (FC) network, any connections that are deployed and using the FC network will be placed into a **Failed** state.
* `found` - Searches for `oneview_uplink_set` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.

:exclamation: **NOTE:** An unmanaged device is used to manually describe any device such as a server, enclosure, storage array, networking switch, tape drive, or display that consumes space in a rack or consumes power but cannot otherwise be managed by the appliance.

Example file: [uplink_set.pp](examples/uplink_set.pp)

#### oneview_volume

This resource provides the following ensurable methods for managing storage volume on the HPE OneView appliance:

* `present` - Creates or updates a volume on the storage system.
* `absent` - Deletes a managed volume only from OneView or OneView and the storage system.
* `found` - Searches for `oneview_volume` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_attachable_volumes` - Gets the volumes that are connected on the specified networks based on the storage system port's expected network connectivity.
* `get_extra_managed_volume_paths` - Gets the list of extra managed storage volume paths.
* `get_snapshot` - Either gets all snapshots of a volume or, if a `snapshotParameters` field is specified and the name of the snapshot is given, gets that specific snapshot.
* `repair` - Removes extra presentation from the volume.
* `create_snapshot` - Creates a snapshot for the specified volume.
* `delete_snapshot` - Deletes a snapshot from OneView and the storage system.


Example file: [volume.pp](examples/volume.pp)

#### oneview_volume_attachment

This resource provides the following ensurable methods for managing storage volume attachments on the HPE OneView appliance:

* `found` - Searches for `oneview_volume_attachment` resources on the appliance. This `found` accepts either no `data` to return all volume attachments, or a `data` containing the `name` key with a "Server Profile Name, Volume Name" combination to find a specific volume attachment.
* `get_extra_unmanaged_volumes` - Gets the list of extra unmanaged storage volumes.
* `remove_extra_unmanaged_volume` - Removes extra presentations from a specified server profile.
* `get_paths` - Either gets all volume attachment paths, or if an `id` is specified, gets the specific volume attachment path.

:exclamation: **NOTE:** The `present` and `absent` ensurable methods are unavailable for this resource. Creation and deletion of this resource is managed by another resource on HPE OneView.

Example file: [volume_attachment.pp](examples/volume_attachment.pp)

#### oneview_volume_template

This resource provides the following ensurable methods for managing storage volume templates on the HPE OneView appliance:

* `present` - Creates or updates a storage volume template.
* `absent` - Deletes the specified storage volume template.
* `found` - Searches for `oneview_volume_template` resources on the appliance (with or without specific filters) and prints the name and uri of matches to the standard output.
* `get_connectable_volume_templates` - Gets the storage volume templates that are available on the specified networks based on the storage system port's expected network connectivity. If no storage volume templates exist that meet the specified connectivity criteria, an empty collection will be returned.

Example file: [volume_template.pp](examples/volume_template.pp)
