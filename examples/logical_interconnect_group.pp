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

oneview_logical_interconnect_group{'Logical Interconnect Group Create':
    ensure => 'present',
    data   => {
      name          => 'My LIG',
      # new_name      => 'Edited Name',
      enclosureType => 'C7000',
      type          => 'logical-interconnect-groupV3'
    }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get LIGs':
    ensure => 'get_logical_interconnect_group',
    data   => {
    }
}

oneview_logical_interconnect_group{'Logical Interconnect Get LIG':
    ensure => 'get_logical_interconnect_group',
    data   => {
      name          => 'My LIG',
      enclosureType => 'C7000',
      type          => 'logical-interconnect-groupV3'
    }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Found':
    ensure => 'found',
    data   => {
      name          => 'My LIG',
      enclosureType => 'C7000',
      type          => 'logical-interconnect-groupV3'
    }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Schema':
    ensure => 'get_schema',
    data   => {
      name          => 'My LIG',
      enclosureType => 'C7000',
      type          => 'logical-interconnect-groupV3'
    }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Default Settings':
    ensure => 'get_default_settings',
    data   => {
      name          => 'My LIG',
      enclosureType => 'C7000',
      type          => 'logical-interconnect-groupV3'
    }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Settings':
    ensure => 'get_settings',
    data   => {
      name          => 'My LIG',
      enclosureType => 'C7000',
      type          => 'logical-interconnect-groupV3'
    }
}
