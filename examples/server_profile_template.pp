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

# This resource requires:
# - Enclosure Group 'EG'
# - Server Hardware Type 'BL460c Gen8 1'
# For newer SDK features (commented blocks):
# - Ethernet Network 'NET'
# - Enclosure Group 'my enclosure'
# - Server Hardware Type 'BL660c Gen8 1'
# - Firmware Driver 'firmware'

oneview_server_profile_template{'Server Profile Template Create':
  ensure => 'present',

  data   =>
    {
      name                  => 'New SPT',
      # You can either declare the name or the uri of the following parameters:
      enclosureGroupUri     => 'EG',
      serverHardwareTypeUri => 'BL460c Gen8 1'
    }
}

oneview_server_profile_template{'Server Profile Template Found':
  ensure  => 'found',
  require => Oneview_server_profile_template['Server Profile Template Create'],
  data    =>
    {
      name => 'New SPT',
    }
}

oneview_server_profile_template{'Server Profile Template Edit':
  ensure  => 'present',
  require => Oneview_server_profile_template['Server Profile Template Found'],
  data    =>
    {
      name     => 'New SPT',
      new_name => 'Edited SPT',
    }
}

oneview_server_profile_template{'Server Profile Template Create #2':
  ensure  => 'present',
  require => Oneview_server_profile_template['Server Profile Template Edit'],
  data    =>
    {
      name                  => 'New SPT #2',
      # You can either declare the name or the uri of the following parameters:
      enclosureGroupUri     => 'EG',
      serverHardwareTypeUri => 'BL460c Gen8 1'
    }
}

oneview_server_profile_template{'Server Profile Template Get All':
  ensure  => 'get_server_profile_templates',
  require => Oneview_server_profile_template['Server Profile Template Create #2'],
}

oneview_server_profile_template{'Server Profile Template Destroy':
  ensure  => 'absent',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name => 'Edited SPT',
    }
}


oneview_server_profile_template{'Server Profile Create':
  ensure  => 'set_new_profile',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name                  => 'New SPT #2',
      # serverProfileName     => 'My SP'
    }
}

# This task will only work once the Server Profile above is deleted
# oneview_server_profile_template{'Server Profile Template Destroy #2':
#   ensure  => 'absent',
#   require => Oneview_server_profile_template['Server Profile Create'],
#   data    =>
#     {
#       name => 'New SPT #2',
#     }
# }

# The following tasks are not available in the resources currently in use
# (enclosure groups and server hardware types cannot be changed)
# oneview_server_profile_template{'Server Profile Template Add Connection':
# ensure  => 'set_connection',
# require => Oneview_server_profile_template['Server Profile Template Destroy'],
#   data  =>
#   {
#     name        => 'New SPT #2',
#     connections =>
#     [
#       {
#         name => 'NET',
#         type => 'EthernetNetwork'
#         # options =>
#         #   {
#         #     This is optional
#         #   }
#       }
#     ]
#   }
# }
#
# oneview_server_profile_template{'Server Profile Template Remove Connection':
#   ensure => 'remove_connection',
#   data   =>
#     {
#       name        => 'New SPT',
#       connections =>
#       [
#         {
#           name => 'NET',
#           type => 'EthernetNetwork'
#         }
#       ]
#     }
# }
#
# oneview_server_profile_template{'Server Profile Template Set EG':
#   ensure => 'set_enclosure_group',
#   data   =>
#     {
#       name           => 'New SPT',
#       enclosureGroup => 'my enclosure'
#     }
# }
#
# oneview_server_profile_template{'Server Profile Template Add SHT':
#   ensure => 'set_server_hardware_type',
#   data   =>
#     {
#       name               => 'New SPT',
#       serverHardwareType => 'BL660c Gen8 1'
#     }
# }
#
# oneview_server_profile_template{'Server Profile Template Set FD':
#   ensure => 'set_firmware_driver',
#   data   =>
#     {
#       name           => 'New SPT',
#       firmwareDriver =>
#       {
#         name    => 'Firmware',
          # options =>
          # {
          #   This is optional
          # }
#       }
#     }
# }
