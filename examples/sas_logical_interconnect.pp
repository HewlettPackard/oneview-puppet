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

oneview_sas_logical_interconnect{'SAS Logical Interconnect Get All':
  ensure => 'found'
}

oneview_sas_logical_interconnect{'SAS Logical Interconnect Get Firmware':
  ensure => 'get_firmware',
  data   =>
    {
      name => 'Puppet_Test_Enclosure-SAS LIG-1'
    }
}

oneview_sas_logical_interconnect{'SAS Logical Interconnect Compliance':
  ensure => 'set_compliance',
  data   =>
    {
      name => 'Puppet_Test_Enclosure-SAS LIG-1'
    }
}

oneview_sas_logical_interconnect{'SAS Logical Interconnect Set Configuration':
  ensure => 'set_configuration',
  data   =>
  {
    name => 'Puppet_Test_Enclosure-SAS LIG-1'
  }
}

# Both the firmware driver identifier and a command need to be specified
# The firmrware driver identifier can be either its name or uri, as follows:
oneview_sas_logical_interconnect{'SAS Logical Interconnect Set Firmware':
  ensure => 'set_firmware',
  data   =>
    {
      name     => 'Puppet_Test_Enclosure-SAS LIG-1',
      firmware =>
      {
        command => 'Stage',
        sspUri  => 'fake_firmware.iso',
        # sspUri  => '/rest/firmware-drivers/fake_firmware',
        force   => false
      }
    }
}

oneview_sas_logical_interconnect{'SAS Logical Interconnect Replace Drive Enclosure':
  ensure => 'replace_drive_enclosure',
  data   =>
  {
    name            => 'Puppet_Test_Enclosure-SAS LIG-1',
    oldSerialNumber => 'SN123100',
    newSerialNumber => 'SN123102'
  }
}
