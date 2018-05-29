################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

# NOTE: Both 'customBaselineName' or simply 'name' are accepted as the single identifier for the custom firmware package.
  # It is required to have exactly one of those on each resource declaration
# NOTE: 1- baselineUri and hotfixUris accept either the uri or names for the drivers
# NOTE: 2- hotfixUris values must be inserted inside an array, enclosed by [].
  # Example: hotfixUris => ['value1', 'value2', 'value3']

oneview_firmware_driver{'firmware_driver_1':
    ensure => 'present',
    data   => {
      customBaselineName => 'FirmwareDriver1_Example',
      # baselineUri        => '/rest/firmware-drivers/SPP2016020_2015_1204_63',
      # hotfixUris         => ['/rest/firmware-drivers/cp022594']
      baselineUri        => 'Service Pack for ProLiant',
      hotfixUris         => ['Online ROM Flash Component for Windows x64 - HPE ProLiant XL260a Gen9 Server']
    },
}

oneview_firmware_driver{'firmware_driver_2':
    ensure => 'found',
    data   => {
      name        => 'FirmwareDriver1_Example',
    },
}

oneview_firmware_driver{'firmware_driver_3':
    ensure => 'absent',
    data   => {
      name        => 'FirmwareDriver1_Example',
    },
}
