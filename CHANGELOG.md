# 2.0.0 (2017-01-05)

### Notes
 This is the Second major version of the Puppet module for the HPE OneView. It extends the support for the OneView API version 300, and
 adds support for Synergy hardware.

### Major changes
 1. Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features:
 - Ethernet network
 - FC network
 - FCOE network
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

### Features supported
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
