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

# This example needs two Ethernet Networks named 'Ethernet 1' and 'Ethernet 2'

# Optional filters for specific network sets
oneview_network_set{'Network Set Get Without Ethernet':
  ensure => 'get_without_ethernet',
  # data   =>
  # {
  #   name          => 'ns1'
  # }
}

oneview_network_set{'Network Set Create':
  ensure => 'present',
  data   =>
  {
    name          => 'Test Network Set',
    nativeNetwork => 'Ethernet 1'
  }
}

# Optional filters
oneview_network_set{'Network Set Get All':
  ensure  => 'found',
  require => Oneview_network_set['Network Set Create'],
  # data   =>
  # {
  #   name => 'ns1'
  # }
}

oneview_network_set{'Network Set Add Network':
  ensure  => 'add_ethernet_network',
  require => Oneview_network_set['Network Set Get All'],
  data    =>
  {
    name             => 'Test Network Set',
    ethernetNetworks => ['Ethernet 1ss', 'Ethernet 2']
  }
}

oneview_network_set{'Network Set Set Native Network':
  ensure  => 'set_native_network',
  require => Oneview_network_set['Network Set Add Network'],
  data    =>
  {
    name          => 'Test Network Set',
    nativeNetwork => 'Ethernet 2'
  }
}

oneview_network_set{'Network Set Remove Network':
  ensure  => 'remove_ethernet_network',
  require => Oneview_network_set['Network Set Set Native Network'],
  data    =>
  {
    name             => 'Test Network Set',
    ethernetNetworks => ['Ethernet 1']
  }
}

oneview_network_set{'Network Set Edit':
  ensure  => 'present',
  require => Oneview_network_set['Network Set Remove Network'],
  data    =>
  {
    name     => 'Test Network Set',
    new_name => 'Edited Name'
  }
}

oneview_network_set{'Network Set Delete':
  ensure  => 'absent',
  require => Oneview_network_set['Network Set Edit'],
  data    =>
  {
    name => 'Edited Name'
  }
}
