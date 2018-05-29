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

# NOTE: Other than the 'found' method, all methods require a name/id for a server hardware to be specified

oneview_server_hardware_type{'server_hardware_type_1':
    ensure => 'present',
    data   => {
      name     => 'BL460c Gen8 1',
      new_name => 'Puppet Test'
    },
}

oneview_server_hardware_type{'server_hardware_type_2':
    ensure => 'present',
    data   => {
      name     => 'Puppet Test',
      new_name => 'BL460c Gen8 1'
    },
}

# The found method accepts data as an optional field to filter out results.
oneview_server_hardware_type{'server_hardware_type_3':
    ensure => 'found',
    # data   => {
    #   name            => 'Puppet Test',
    # },
}

# Absent can only remove a server hardware type if it is not in use.
# oneview_server_hardware_type{'server_hardware_type_4':
#     ensure => 'absent',
#     data   => {
#       name            => 'BL460c Gen8 1',
#     },
# }
