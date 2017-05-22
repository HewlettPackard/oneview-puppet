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

# NOTE: The only ensurable permitted for Firmware Bundles is 'present'
# NOTE: A 'firmware_bundle_path' pointing to the image is required inside 'data'
oneview_firmware_bundle{'firmware_bundle_1':
    ensure => 'present',
    data   => {
      # firmware_bundle_path => './spec/support/cp022594.exe'
      firmware_bundle_path => 'E:\cp020307.exe' # For Puppet on windows use Windows Pathing
    },
}
