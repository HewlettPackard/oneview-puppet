################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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
# NOTE: As a pre-requisite, create 2 ethernet networks and provide those uris in bulk delete example

oneview_ethernet_network{'Ethernet Network Create':
  ensure => 'present',
  data   => {
    name           => 'Puppet network',
    vlanId         => '1045',
    purpose        => 'General',
    smartLink      => true,
    privateNetwork => false,
  }
}

oneview_ethernet_network{'Ethernet Network Associated Profiles':
  ensure  => 'get_associated_profiles',
  require => Oneview_ethernet_network['Ethernet Network Create'],
  data    => {
    name => 'Puppet network'
  }
}

oneview_ethernet_network{'Ethernet Network Uplink Groups':
  ensure  => 'get_associated_uplink_groups',
  require => Oneview_ethernet_network['Ethernet Network Associated Profiles'],
  data    => {
    name => 'Puppet network'
  }
}

oneview_ethernet_network{'Ethernet Network Default Bandwidth':
  ensure  => 'reset_default_bandwidth',
  require => Oneview_ethernet_network['Ethernet Network Uplink Groups'],
  data    => {
    name => 'Puppet network'
  }
}

oneview_ethernet_network{'Ethernet Network Update':
  ensure  => 'present',
  require => Oneview_ethernet_network['Ethernet Network Default Bandwidth'],
  data    =>
  {
    name      => 'Puppet network',
    new_name  => 'Updated',
    bandwidth => {
      maximumBandwidth => 16000
    }
  }
}

oneview_ethernet_network{'Ethernet Network Found #1':
  ensure  => 'found',
  require => Oneview_ethernet_network['Ethernet Network Update'],
  data    => {
    name => 'Updated'
  }
}

oneview_ethernet_network{'Ethernet Network Found #2':
  ensure  => 'found',
  require => Oneview_ethernet_network['Ethernet Network Found #1'],
  data    => {
    vlanId => '1045',
  }
}

oneview_ethernet_network{'Ethernet Network Delete':
  ensure  => 'absent',
  require => Oneview_ethernet_network['Ethernet Network Found #2'],
  data    => {
    name => 'Updated'
  }
}

# Bulk Ethernet Networks
oneview_ethernet_network{'Bulk Create':
    ensure => 'present',
    data   => {
      vlanIdRange    => '26-27',
      purpose        => 'General',
      namePrefix     => 'Puppet',
      smartLink      => false,
      privateNetwork => false,
      bandwidth      =>
      {
        maximumBandwidth => '10_000',
        typicalBandwidth => '2000'
      }
    }
}

oneview_ethernet_network{'Bulk Delete 1':
    ensure  => 'absent',
    require => Oneview_ethernet_network['Bulk Create'],
    data    => {
      name => 'Puppet_26'
    }
}

oneview_ethernet_network{'Bulk Delete 2':
    ensure  => 'absent',
    require => Oneview_ethernet_network['Bulk Delete 1'],
    data    => {
      name => 'Puppet_27'
    }
}

# Bulk delete Ethernet Networks is supported from API1800
oneview_ethernet_network{'Bulk Delete':
    ensure => 'present',
    data   => {
      networkUris    => [ 'Test1', 'Test2' ]
    }
}

