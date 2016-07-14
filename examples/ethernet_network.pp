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

oneview_ethernet_network{'net1':
    ensure => 'present',
    data   => {
      name                  => 'Puppet network',
      vlanId                => '1045',
      purpose               => 'General',
      smartLink             => true,
      privateNetwork        => false,
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}
oneview_ethernet_network{'net2':
    ensure  => 'present',
    require => Oneview_ethernet_network['net1'],
    data    => {
      name                  => 'Puppet network',
      new_name              => 'Updated',
      vlanId                => '1045',
      purpose               => 'General',
      smartLink             => true,
      privateNetwork        => false,
      connectionTemplateUri => 'nil',
      type                  => 'ethernet-networkV3'
    }
}

oneview_ethernet_network{'net3':
    ensure  => 'found',
    require => Oneview_ethernet_network['net2'],
    data    => {
      name                  => 'Updated'
    }
}

oneview_ethernet_network{'net4':
    ensure  => 'found',
    require => Oneview_ethernet_network['net3'],
    data    => {
      vlanId                => '1',
    }
}


oneview_ethernet_network{'net5':
    ensure  => 'absent',
    require => Oneview_ethernet_network['net4'],
    data    => {
      name                  => 'Updated'
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
