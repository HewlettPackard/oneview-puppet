# v6.0.0(2021-03-10)
### Notes
- This release extends support of the SDK to Oneview REST API version 2600 (OneView v6.00) and ImageStreamer REST API version 2010 (I3S v6.00).

### Oneview Features supported
- Connection Template
- Enclosure
- Enclosure Group
- Ethernet Network
- FC Network
- FCOE Network
- Hypervisor Cluster Profile
- Hypervisor Manager
- Interconnect
- Interconnect Types
- Logical Enclosure
- Logical Interconnect
- Logical Interconnect Groups
- Network Set
- OS Deployment Plan
- Server Certificate
- Server Hardware
- Server Hardware Type
- Server Profile
- Server Profile Template
- Storage Pool
- Storage System
- Storage Volume Template
- Uplink Set
- Volume
- Volume Attachment

### Image Streamer support
- Artifact Bundle
- Build Plan
- Deployment Group
- Deployment Plan
- Golden Image
- OS Volume
- Plan Script


# v2.10.0(2021-02-16)
### Notes
- This release extends support of the SDK to Oneview REST API version 2400 (OneView v5.60).

### Oneview Features supported
- Connection Template
- Enclosure
- Enclosure Group
- Ethernet Network
- FC Network
- FCOE Network
- Hypervisor Cluster Profile
- Hypervisor Manager
- Interconnect
- Interconnect Types
- Logical Enclosure
- Logical Interconnect
- Logical Interconnect Groups
- Network Set
- OS Deployment Plan
- Server Certificate
- Server Hardware
- Server Hardware Type
- Server Profile
- Server Profile Template
- Storage Pool
- Storage System
- Storage Volume Template
- Uplink Set
- Volume
- Volume Attachment

#### Bug fixes & Enhancements:
- [#301] (https://github.com/HewlettPackard/oneview-puppet/issues/301) Failing to create a oneview enclosure group with ipRangeUris
- [#304] (https://github.com/HewlettPackard/oneview-puppet/issues/304) Failing to create a oneview logical interconnect group with real networkUris
- [#315] (https://github.com/HewlettPackard/oneview-puppet/issues/315) Failing to create oneview_server_profile_tempate with connections

# v2.9.0(2020-11-11)
### Notes
- This release extends support of the SDK to Oneview REST API version 2200 (OneView v5.50) and ImageStreamer REST API version 2000 (I3S v5.40).

### Oneview Features supported
- Connection Template
- Enclosure
- Enclosure Group
- Ethernet Network
- FC Network
- FCOE Network
- Hypervisor Cluster Profile
- Hypervisor Manager
- Interconnect
- Interconnect Types
- Logical Enclosure
- Logical Interconnect
- Logical Interconnect Groups
- Network Set
- OS Deployment Plan
- Server Certificate
- Server Hardware
- Server Hardware Type
- Server Profile
- Server Profile Template
- Storage Pool
- Storage System
- Storage Volume Template
- Uplink Set
- Volume
- Volume Attachment

### Image Streamer support
- Artifact Bundle
- Build Plan
- Deployment Plan
- Deployment Group
- Golden Image
- OS Volume
- Plan Script

# v2.8.0(2020-09-25)
### Notes
- This release extends support of the SDK to Oneview REST API version 2000 (OneView v5.40).

#### Bug fixes & Enhancements:
- Enhanced the method to set the default API version to appliance's max API version if the API version is not given.

### Oneview Features supported
- Connection Template
- Enclosure
- Enclosure Group
- Ethernet Network
- FC Network
- FCOE Network
- Hypervisor Cluster Profile
- Hypervisor Manager
- Interconnect
- Interconnect Types
- Logical Enclosure
- Logical Interconnect
- Logical Interconnect Groups
- Network Set
- Server Certificate
- Server Hardware
- Server Hardware Type
- Server Profile
- Server Profile Template
- Storage Pool
- Storage System
- Storage Volume Template
- Uplink Set
- Volume
- Volume Attachment

# v2.7.0(2020-08-04)
### Notes
- This release extends support of the SDK to OneView REST API version 1800 (OneView v5.30).

### Oneview Features supported
- Connection Template
- Enclosure
- Enclosure Group
- Ethernet Network
- FC Network
- FCOE Network
- Hypervisor Cluster Profile
- Hypervisor Manager
- Interconnect
- Logical Enclosure
- Logical Interconnect
- Logical Interconnect Group
- Network Set
- Server Certificate
- Server Hardware
- Server Hardware Type
- Server Profile
- Server Profile Template
- Storage Pool
- Storage System
- Storage Volume Template
- Uplink Set
- Volume
- Volume Attachment

# v2.6.0(2020-06-08)
### Notes
- This release extends support of the SDK to OneView REST API version 1600 (OneView v5.20).

### Oneview Features supported
- Connection Template
- Enclosure
- Enclosure Group
- Ethernet Network
- FC Network
- FCOE Network
- Hypervisor Cluster Profile
- Hypervisor Manager
- Interconnect
- Logical Enclosure
- Logical Interconnect
- Logical Interconnect Group
- Network Set
- Server Certificate
- Server Hardware
- Server Hardware Type
- Server Profile
- Server Profile Template
- Storage pool
- Storage system
- Storage volume template
- Uplink Set
- Volume
- Volume attachment

### Image Streamer support
- Artifact Bundle
- Deployment plan

### Bug fixes & Enhancements:
- [#245](https://github.com/HewlettPackard/oneview-puppet/issues/245)LIG is not getting created with uplinkset of networkType FCNetwork
- [#254](https://github.com/HewlettPackard/oneview-puppet/issues/254)Make oneview-puppet module compatible with PDK

# v2.5.0 (2020-04-27)
### Notes
- This release supports OneView Rest API versions 800/1000/1200 for Hypervisor resources.
- Added support to Server Certificate REST API version 600/800/1000/1200 through OneView.
- Added usecases for the following scenarios
  1. Infrastructure provisioning with OS on Synergy with Image Streamer.
  2. Infrastructure provisioning on Synergy with compute (with server settings), networking, and storage.
  3. Create and update infrastructure provisioning on Synergy with JBODS.

### Oneview Features supported
- Hypervisor Cluster Profile
- Hypervisor Manager
- Server Certificate

### Bug fixes & Enhancements:
- [#236](https://github.com/HewlettPackard/oneview-puppet/issues/236) Dockerfile is failing because of incorrect Ruby version.

# v2.4.0 (2020-03-03)
### Notes
- This release supports OneView Rest API versions 800/1000/1200 minimally where we can use OneView v4.10/v4.20/v5.0 with this SDK. No new fields are added/deleted to support OneView Rest API 800/1000/1200. Complete support will be done in next releases.

### Bug fixes & Enhancements:
- [#215](https://github.com/HewlettPackard/oneview-puppet/issues/215) Creating a Server Profile based on a Template does not autofill its blank attributes with the template's
- [#218](https://github.com/HewlettPackard/oneview-puppet/issues/218) Not able to pass connection names in the SPT creation as the networkUri is not parsing in the connectionSettings

### Oneview Features supported
- Connection template
- Ethernet network
- Enclosure
- Enclosure group
- FC network
- FCoE network
- Interconnect
- Interconnect link topology
- Interconnect type
- Logical enclosure
- Logical interconnect
- Logical interconnect group
- Network set
- SAS logical interconnect
- Server hardware
- Server hardware type
- Server profile
- Server profile template
- Storage pool
- Storage system
- Storage volume template
- Uplink set
- Volume
- Volume attachment

### Image Streamer support
- Deployment plan

# v2.3.0 (2018-06-26)
### Version highlights:
1. Added full support to OneView Rest API version 500 and 600 for the hardware variants C7000 and Synergy to the already existing features.
2. Added support to the Image Streamer REST API version 500 and 600 for OS provisioning through OneView
3. Added new common method `load_resource`, which should improve efficiency when loading resources of different resource types
4. Added [TESTING.md](TESTING.md) file to explain the testing strategy in the module.
5. Solved security issues regarding Rubocop by updating the gem dependency to use the latest version currently available (0.51.0).

#### Bug fixes & Enhancements:
- [#123](https://github.com/HewlettPackard/oneview-puppet/issues/123) Remove rest call from tests
- [#165](https://github.com/HewlettPackard/oneview-puppet/issues/165) Creating a Server Profile based on a Template does not autofill its blank attributes with the template's
- [#172](https://github.com/HewlettPackard/oneview-puppet/issues/172) Unit tests updated for ruby version 2.4.0 and above.
- [#207](https://github.com/HewlettPackard/oneview-puppet/issues/207) Server Profile Template update not working

##### Security specific issues:
- [#169](https://github.com/HewlettPackard/oneview-puppet/issues/169) Update rubocop to latest version

### Notes
This release extends the full support for the Synergy and C7000 APIs to all the resources previously supported.

### Oneview Features supported
- Connection template
- Enclosure group
- Ethernet network
- FC network
- FCoE network
- Internal link set
- Interconnect
- Interconnect link topology
- Interconnect type
- Logical enclosure
- Logical interconnect
- Logical interconnect group
- Logical switch
- Logical switch group
- Managed san
- Network set
- OS deployment plan
- SAS interconnect
- SAS interconnect type
- SAS logical interconnect
- SAS logical interconnect group
- SAS logical JBOD
- SAS logical JBOD attachment
- Server hardware
- Server profile
- Server profile template
- Storage pool
- Storage system
- Storage volume template
- Switch
- Switch type
- Uplink set
- Volume

### Image Streamer support
- Deployment plan
- Golden image
- OS build plan
- OS volume
- Plan script

# v2.2.2 (2017-07-07)
### Version highlights:
1. Provider names are now case insensitive
2. Added the 'oneview' Puppet feature to require the 'oneview-sdk'

#### Bug fixes & Enhancements:
- [#159](https://github.com/HewlettPackard/oneview-puppet/issues/159) Provider name should not be case sensitive
- [#161](https://github.com/HewlettPackard/oneview-puppet/issues/161) Add rescue to requirement of 'oneview-sdk' to avoid catalog issues

# v2.2.1 (2017-05-22)
### Version highlights:
1. Major refactor on internal methods. Improved idempotency, logging project-wide and reduced lines of code count.
2. Raised 'oneview-sdk' version used to ~> 4.4.
3. Several bugfixes and improvements.

#### Bug fixes & Enhancements:
- [#95](https://github.com/HewlettPackard/oneview-puppet/issues/95) Improve server profile idempotency
- [#101](https://github.com/HewlettPackard/oneview-puppet/issues/101) Improve server profile template idempotency
- [#145](https://github.com/HewlettPackard/oneview-puppet/issues/145) Refactor oneview_resource class and common for v2.2.0
- [#148](https://github.com/HewlettPackard/oneview-puppet/issues/148) Cannot create uplinkset for LIG on a Synergy frame
- [#149](https://github.com/HewlettPackard/oneview-puppet/issues/149) Server Profile - Network uris set inside the connections return error
- [#151](https://github.com/HewlettPackard/oneview-puppet/issues/151) SAS Logical Interconnect Group - Name to URI conversion fails on logicalInterconnectGroupUri fields
- [#153](https://github.com/HewlettPackard/oneview-puppet/issues/153) Idempotence error: Running a ensure => 'present' on a oneview_firmware_bundle resource

# 2.2.0 (2017-03-28)
### Version highlights:
1. Added support to the Image Streamer REST API version 300 for OS provisioning through OneView.

### Puppet Types Added
- Image_streamer_artifact_bundle
- Image_streamer_build_plan
- Image_streamer_deployment_group
- Image_streamer_deployment_plan
- Image_streamer_golden_image
- Image_streamer_os_volume
- Image_streamer_plan_script

#### Bug fixes & Enhancements:
- [#103](https://github.com/HewlettPackard/oneview-puppet/issues/103) Unit tests should not require auth files/environment variables from the user
- [#105](https://github.com/HewlettPackard/oneview-puppet/issues/105) Create or update uplink sets through logical interconnect groups
- [#116](https://github.com/HewlettPackard/oneview-puppet/issues/116) Simplify login to i3s
- [#119](https://github.com/HewlettPackard/oneview-puppet/issues/119) Update unit tests to match updated remove_extra_unmanaged_volume from oneview-ruby-sdk
- [#121](https://github.com/HewlettPackard/oneview-puppet/issues/121) Deployment Plan and Golden Image should use the default uri parser
- [#122](https://github.com/HewlettPackard/oneview-puppet/issues/122) Uri_parsing should support upper case for uri
- [#132](https://github.com/HewlettPackard/oneview-puppet/issues/132) Allow option force for Image_streamer_golden_image download operations
- [#133](https://github.com/HewlettPackard/oneview-puppet/issues/133) Allow set a timeout for Image_streamer_golden_image upload
- [#139](https://github.com/HewlettPackard/oneview-puppet/issues/139) Error running oneview_logical_interconnect's ensure method get_default_settings after upgrading OneView SDK to >= v4.1

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
