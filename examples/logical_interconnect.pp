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

oneview_logical_interconnect{'Logical Interconnect Found':
  ensure => 'found',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
    }
}

oneview_logical_interconnect{'Logical Interconnect QoS Get':
  ensure => 'get_qos_aggregated_configuration',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
    }
}

oneview_logical_interconnect{'Logical Interconnect QoS Set':
  ensure => 'set_qos_aggregated_configuration',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
      qosConfiguration =>
      {
        activeQosConfig =>
        {

          uplinkClassificationType => 'DOT1P'
        }
      }
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
      name             => 'Encl2-my enclosure logical interconnect group',
    }
}

oneview_logical_interconnect{'Logical Interconnect Internal Vlan':
  ensure => 'get_internal_vlans',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
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
        enabled => true
      }
    }
}



oneview_logical_interconnect{'Logical Interconnect Compliance':
  ensure => 'set_compliance',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
    }
}

oneview_logical_interconnect{'Logical Interconnect Internal Networks':
  ensure => 'set_internal_networks',
  data   =>
    {
      name             => 'Encl2-my enclosure logical interconnect group',
      internalNetworks =>
      {
        e1 =>
        {
          name => 'NET',
        }
      }
    }
}
