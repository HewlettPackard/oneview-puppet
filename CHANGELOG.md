# 2.1.0 (2017-02-TBD)
### Version highlights:
1. Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features.
2. Implemented a Oneview_resource class for the resources to inherit from, reducing code duplication and complexity.
3. Enabled the 'puppet resource <oneview_type>' for most of the providers, allowing the resources to be queried.
4. Overall refactor and code cleanup.

### Notes
This release extends the full support for the Synergy and C7000 APIs to all the resources previously supported, and adds a few new resources specific to Synergy.

### Puppet Types Added
- Oneview_drive_enclosure
- Oneview_sas_interconnect
- Oneview_sas_logical_interconnect
- Oneview_sas_logical_interconnect_group

### Oneview Features supported
- Connection template
- Datacenter
- Enclosure
- Ethernet network
- Fabrics
- FC network
- FCoE network
- Firmware bundles
- Firmware drivers
- Interconnect
- Logical downlink
- Logical enclosure
- Logical interconnect
- Logical interconnect Group
- Uplink Set
- Logical switch
- Logical switch group
- Managed SANs
- Network set
- Power devices
- Racks
- SAN managers
- Server hardware
- Server hardware type
- Server profile
- Server profile template
- Storage pools
- Storage systems
- Switches
- Volume
- Volume attachment
- Volume template
- Drive Enclosures
- Interconnect Link Topology
- Internal Link Set
- SAS Interconnect
- SAS Interconnect Type
- SAS Logical Interconnect
- SAS Logical Interconnect Group
- SAS Logical JBOD Attachments
- SAS Logical JBODs
- Unmanaged devices

# 2.0.0 (2017-01-05)

### Notes
 This is the Second major version of the Puppet module for the HPE OneView. It extends the support for the OneView API version 300, and
 adds support for Synergy hardware.

### Major changes
 1. Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features:
 - Ethernet network
 - FC network
 - FCoE network
 - Network set
 2. Support to Synergy hardware has been added. The 'hardware_variant' option is specified in the client and the providers in this module handle the correct execution.
 3. Updated the requirements for the module for using the oneview-sdk gem with versions greated than 3.0.0.

### 1.0.1 (2016-11-28)
 * Added the .travis.yml file to the root of the project
 * Configured continuous integration with Travis CI for the repository
 * Disabled BlockLength for rubocop
 * Added OS Support to metadata file
 * Added shields to the README.md file
 * Fixed issue on one of the firmware bundle unit tests

# 1.0.0 (2016-10-06)
### Notes
  This is the official release of the Puppet module for the HPE OneView. It features the creation of providers and types needed for managing OneView resources, example files for each type created, as well as a full set of unit and integration tests for each type and provider, with total code coverage averaging over 90%. For now it only supports C7000 enclosure types.

### Summary

 * Created all resources types and providers for the OneView API 200
 * Created smoke, unit, and integration tests for all resources

### Puppet Types Added
- Oneview_ethernet_network
- Oneview_fc_network
- Oneview_fcoe_network
- Oneview_network_set
- Oneview_connection_template
- Oneview_fabric
- Oneview_san_manager
- Oneview_managed_san
- Oneview_interconnect
- Oneview_logical_interconnect
- Oneview_logical_interconnect_group
- Oneview_uplink_set
- Oneview_logical_downlink
- Oneview_enclosure
- Oneview_logical_enclosure
- Oneview_enclosure_group
- Oneview_firmware_bundle
- Oneview_firmware_driver
- Oneview_storage_system
- Oneview_storage_pool
- Oneview_volume
- Oneview_volume_template
- Oneview_datacenter
- Oneview_racks
- Oneview_logical_switch_group
- Oneview_logical_switch
- Oneview_switch
- Oneview_power_devices
- Oneview_server_profile
- Oneview_server_profile_template
- Oneview_server_hardware
- Oneview_server_hardware_type
- Oneview_unmanaged_devices

### Oneview Features supported
 - Ethernet network
 - FC network
 - FCOE network
 - Network set
 - Connection template
 - Fabric
 - SAN manager
 - Managed SAN
 - Interconnect
 - Logical interconnect
 - Logical interconnect group
 - Uplink set
 - Logical downlink
 - Enclosure
 - Logical enclosure
 - Enclosure group
 - Firmware bundle
 - Firmware driver
 - Storage system
 - Storage pool
 - Volume
 - Volume template
 - Datacenter
 - Racks
 - Logical switch group
 - Logical switch
 - Switch
 - Power devices
 - Server profile
 - Server profile template
 - Server hardware
 - Server hardware type
 - Unmanaged devices
