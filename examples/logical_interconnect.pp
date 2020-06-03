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

oneview_logical_interconnect{'Logical Interconnect Found':
  ensure => 'found',
  data   =>
    {
      name => 'Encl2-my enclosure logical interconnect group'
    }
}

oneview_logical_interconnect{'Logical Interconnect Get All':
  ensure => 'found'
}

oneview_logical_interconnect{'Logical Interconnect QoS Get':
  ensure => 'get_qos_aggregated_configuration',
  data   =>
    {
      name => 'Encl2-my enclosure logical interconnect group'
    }
}

oneview_logical_interconnect{'Logical Interconnect Port Monitor Set':
  ensure => 'set_port_monitor',
  data   =>
    {
      name        => 'Encl2-my enclosure logical interconnect group',
      portMonitor =>
      {
        enablePortMonitor => false
      }
    }
}

oneview_logical_interconnect{'Logical Interconnect Port Monitor Get':
  ensure => 'get_port_monitor',
  data   =>
    {
      name => 'Encl2-my enclosure logical interconnect group',
    }
}

oneview_logical_interconnect{'Logical Interconnect Internal Vlan':
  ensure => 'get_internal_vlans',
  data   =>
    {
      name => 'Encl2-my enclosure logical interconnect group'
    }
}

oneview_logical_interconnect{'Logical Interconnect SNMP Config Get':
  ensure => 'get_snmp_configuration',
  data   =>
    {
      name              => 'Encl2-my enclosure logical interconnect group',
      snmpConfiguration =>
      {
        enabled => false
      }
    }
}

oneview_logical_interconnect{'Logical Interconnect SNMP Config Set':
  ensure => 'set_snmp_configuration',
  data   =>
    {
      name              => 'Encl2-my enclosure logical interconnect group',
      snmpConfiguration =>
      {
        enabled       => true,
        readCommunity => 'public
      }
    }
}

oneview_logical_interconnect{'Logical Interconnect Compliance':
  ensure => 'set_compliance',
  data   =>
    {
      name => 'Encl2-my enclosure logical interconnect group'
    }
}

oneview_logical_interconnect{'Logical Interconnect Internal Networks':
  ensure => 'set_internal_networks',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
      internalNetworks => ['NET', 'Ethernet 1']
    }
}

oneview_logical_interconnect{'Logical Interconnect Set Configuration':
  ensure => 'set_configuration',
  data   =>
  {
    name => 'Encl2-my enclosure logical interconnect group'
  }
}

# Both the firmware driver identifier and a command need to be specified
# The firmrware driver identifier can be either its name or uri, as follows:
oneview_logical_interconnect{'Logical Interconnect Set Firmware':
  ensure => 'set_firmware',
  data   =>
    {
      name     => 'Encl2-my enclosure logical interconnect group',
      firmware =>
      {
        command => 'Stage',
        sspUri  => 'fake_firmware.iso',
        # sspUri  => '/rest/firmware-drivers/fake_firmware',
        force   => false
      }
    }
}
