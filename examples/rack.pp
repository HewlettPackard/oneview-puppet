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
# duplicate names for your racks

oneview_rack{'rack_1':
    ensure => 'present',
    data   => {
      'name' => 'myrack'
    },
}

oneview_rack{'rack_2':
    ensure => 'present',
    data   => {
      'name' => 'myrack',
      "depth" => 1500,
      "height" => 2500,
      "width" => 1200,
    },
}

# The absent ensurable accepts a name, but in case more than one resource with the same name exist
# it will cause a failure. For these operations it is safer to use an id or uri.
oneview_rack{'rack_3':
    ensure => 'absent',
    data   => {
      'name' => 'myrack'
    },
}
