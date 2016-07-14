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

oneview_uplink_set{'uplink_set_1':
    ensure               => 'present',
    data                 => {
      nativeNetworkUri               => 'nil',
      reachability                   => 'Reachable',
      manualLoginRedistributionState => 'NotSupported',
      connectionMode                 => 'Auto',
      lacpTimer                      => 'Short',
      networkType                    => 'Ethernet',
      ethernetNetworkType            => 'Tagged',
      description                    => 'nil',
      name                           => 'Puppet Uplink Set',
    },
    network              => 'Puppet Test EthNetwork',
    logical_interconnect => 'Encl1-Test Oneview'
}

oneview_uplink_set{'uplink_set_2':
    ensure               => 'present',
    require              => Oneview_uplink_set['uplink_set_1'],
    data                 => {
      nativeNetworkUri               => 'nil',
      reachability                   => 'Reachable',
      manualLoginRedistributionState => 'NotSupported',
      connectionMode                 => 'Auto',
      lacpTimer                      => 'Short',
      networkType                    => 'Ethernet',
      ethernetNetworkType            => 'Tagged',
      description                    => 'nil',
      name                           => 'Puppet Uplink Set',
      new_name                       => 'Puppet Uplink Set Updated'
    },
    network              => 'Puppet Test EthNetwork',
    logical_interconnect => 'Encl1-Test Oneview'
}

oneview_uplink_set{'uplink_set_3':
    ensure  => 'found',
    require => Oneview_uplink_set['uplink_set_2'],
    data    => {
      connectionMode      => 'Auto',
      lacpTimer           => 'Short',
      networkType         => 'Ethernet',
      ethernetNetworkType => 'Tagged',
      description         => 'nil',
      name                => 'Puppet Uplink Set Updated',
    }
}

oneview_uplink_set{'uplink_set_4':
    ensure  => 'absent',
    require => Oneview_uplink_set['uplink_set_3'],
    data    => {
      name => 'Puppet Uplink Set Updated'
    }
}
