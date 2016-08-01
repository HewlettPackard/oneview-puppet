################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

# NOTE: The names are not unique identifiers for this resource, but we highly suggest avoiding
# duplicate names for your racks in order to allow for updates using the names. This module will
# enforce name as a unique identifier for that reason.

oneview_rack{'rack_1':
    ensure => 'present',
    data   => {
      'name'   => 'myrack'
    },
}

oneview_rack{'rack_2':
    ensure => 'present',
    data   => {
      'name'   => 'myrack',
      'depth'  => 1500,
      'height' => 2500,
      'width'  => 1200,
    },
}

oneview_rack{'rack_3':
    ensure => 'get_device_topology',
    data   => {
      'name'   => 'myrack'
    },
}

oneview_rack{'rack_4':
    ensure => 'add_rack_resource',
    data   => {
      'name'       => 'myrack',
      'rackMounts' => [
      # {"mountUri" => '/rest/enclosures/09SGH100X6J1', "topUSlot"=> 20, "uHeight"=> 10}
      {
      'mountUri' => 'Encl1, enclosure',
      'topUSlot' => 20,
      'uHeight'  => 10}
      ]
    },
}

oneview_rack{'rack_5':
    ensure => 'remove_rack_resource',
    data   => {
      'name'       => 'myrack',
      'rackMounts' => [
      # {"mountUri" => '/rest/enclosures/09SGH100X6J1', "topUSlot"=> 20, "uHeight"=> 10}
      {
        'mountUri' => 'Encl1, enclosure',
        'topUSlot' => 20,
        'uHeight'  => 10}
      ]
    },
}

# The absent ensurable accepts general filters when deleting racks and can delete multiple racks at once.
  # Caution is advised if a unique identifier is not used when deleting racks.
oneview_rack{'rack_6':
    ensure => 'absent',
    data   => {
          'name' => 'myrack'
    },
}
