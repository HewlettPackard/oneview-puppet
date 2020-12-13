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

# Create a Logical Enclosure. Supported in Synergy only
 oneview_logical_enclosure{'logical_enc0':
     ensure  => 'present',
     data    => {
       name                      =>  'Puppet_Test_Enclosure',
       enclosureUris             =>  ['/rest/enclosures/0000000000A66101',  '/rest/enclosures/0000000000A66102', '/rest/enclosures/0000000000A66103'],
       enclosureGroupUri         =>  '',
       firmwareBaselineUri       =>  'null',
       forceInstallFirmware       =>  'false',
     }
 }


#Reapply configuration of Logical Enclosure
oneview_logical_enclosure{'logical_enc1':
    ensure => 'reapply_configuration',
    data   => {
      name                      =>  '',
    }
}

#Get configuration script of LE. Supported in C7000 only.
oneview_logical_enclosure{'logical_enc2':
    ensure => 'get_script',
    data   => {
      name                      =>  '',
    }
}

#Set configuration script for Logical Enclosure. Supported in C7000 only.
oneview_logical_enclosure{'logical_enc3':
    ensure => 'set_script',
    data   => {
      name   =>  '',
      script =>  'This is a script example',
    }
}

#Logical Enclosure -  Update from Group 
oneview_logical_enclosure{'logical_enc5':
    ensure => 'updated_from_group',
    data   => {
      name                      =>  '',
    }
}

#Generate support dump of Logical Enclosure.
oneview_logical_enclosure{'logical_enc6':
    ensure => 'generate_support_dump',
    data   => {
      name =>  '',
      dump =>
        {
          errorCode            => 'Mydump',
          excludeApplianceDump => false
        }
    }
}

# Delete the Logical Enclsoure. Supported in Synergy only.
#oneview_logical_enclosure{ 'destroy' :
 #   ensure => 'absent',
  #  data => {
   #     name => 'Puppet_Test_Enclosure'
   # }
#}

