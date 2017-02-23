# Unreleased Changes

## Suggested release: v2.2.0
### Version highlights:
1. Added support to the Image Streamer REST API version 300 for OS provisioning through OneView.

### Puppet Types Added
- Image_streamer_os_volume
- Image_streamer_plan_script

#### Bug fixes & Enhancements:
- [#105](https://github.com/HewlettPackard/oneview-puppet/issues/105) Create or update uplink sets through logical interconnect groups
- [#119](https://github.com/HewlettPackard/oneview-puppet/issues/119) Build is failing due to a recent change on the method remove_extra_unmanaged_volume

# 2.1.0 (2017-02-03)
### Version highlights:
1. Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features.
2. Implemented the Oneview_resource class to act as parent for the other resources, reducing code duplication and complexity.
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
- Drive enclosure
- Enclosure
- Enclosure group
- Ethernet network
- Fabric
- FC network
- FCoE network
- Firmware bundle
- Firmware driver
- Interconnect
- Interconnect link topology
- Internal link set
- Logical downlink
- Logical enclosure
- Logical interconnect
- Logical interconnect group
- Logical switch
- Logical switch group
- Managed SAN
- Network set
- Power device
- Rack
- SAN manager
- SAS interconnect
- SAS interconnect type
- SAS logical interconnect
- SAS logical interconnect group
- SAS logical JBOD
- SAS logical JBOD attachment
- Server hardware
- Server hardware type
- Server profile
- Server profile template
- Storage pool
- Storage system
- Switch
- Unmanaged device
- Uplink set
- Volume
- Volume attachment
- Volume template

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
- Oneview_connection_template
- Oneview_datacenter
- Oneview_enclosure
- Oneview_enclosure_group
- Oneview_ethernet_network
- Oneview_fabric
- Oneview_fc_network
- Oneview_fcoe_network
- Oneview_firmware_bundle
- Oneview_firmware_driver
- Oneview_interconnect
- Oneview_logical_downlink
- Oneview_logical_enclosure
- Oneview_logical_interconnect
- Oneview_logical_interconnect_group
- Oneview_logical_switch
- Oneview_logical_switch_group
- Oneview_managed_san
- Oneview_network_set
- Oneview_power_device
- Oneview_racks
- Oneview_san_manager
- Oneview_server_hardware
- Oneview_server_hardware_type
- Oneview_server_profile
- Oneview_server_profile_template
- Oneview_storage_pool
- Oneview_storage_system
- Oneview_switch
- Oneview_unmanaged_device
- Oneview_uplink_set
- Oneview_volume
- Oneview_volume_attachment
- Oneview_volume_template

### Oneview Features supported
- Connection template
- Datacenter
- Enclosure
- Enclosure group
- Ethernet network
- Fabric
- FC network
- FCOE network
- Firmware bundle
- Firmware driver
- Interconnect
- Logical downlink
- Logical enclosure
- Logical interconnect
- Logical interconnect group
- Logical switch
- Logical switch group
- Managed SAN
- Network set
- Power device
- Racks
- SAN manager
- Server hardware
- Server hardware type
- Server profile
- Server profile template
- Storage pool
- Storage system
- Switch
- Unmanaged device
- Uplink set
- Volume
- Volume attachment
- Volume template
