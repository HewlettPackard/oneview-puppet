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

# This example requires:
# A server hardware '172.18.6.15'

# Some get endpoints accept query parameters. Please check the API reference for more
# information on which filters can be used

# As the patch operation only supports one specific set of values, it has been replaced
# by 'update_from_template'
# The server template needs to be associated with a profile in order to perform this action
# oneview_server_profile{'Server Profile Update From Template':
#   ensure  => 'update_from_template',
#   require => Oneview_server_profile['Server Profile Found'],
#   data    =>
#   {
#     name => 'Test Server Profile'
#   }
# }

oneview_server_profile{'Server Profile Get Available Targets':
  ensure => 'get_available_targets',
  data   => {
    query_parameters  => {
      enclosureGroupUri       => 'EG'
    }
  }
}

oneview_server_profile{'Server Profile Get Available Networks':
  ensure => 'get_available_networks',
  data   => {
    query_parameters  => {
      enclosureGroupUri     => 'EG',
      serverHardwareTypeUri => 'SY 480 Gen9 2'
    }
  }
}

# The method #get_available_server is available till API 1200.
oneview_server_profile{'Server Profile Get Available Servers':
  ensure => 'get_available_servers',
  data   => {
      query_parameters  => {
        enclosureGroupUri        => 'EG'
      }
    }
}

oneview_server_profile{'Server Profile Create':
  ensure => 'present',
  data   =>
  {
    type              => 'ServerProfileV12',
    name              => 'Test Server Profile',
    serverHardwareUri => '0000A66101, bay 7',
  }
}

# Optional filters
oneview_server_profile{'Server Profile Found':
  ensure => 'found',
  data   => {
    name             => 'Test Server Profile'
  }
}

# This ensure method is only available for Synergy Hardware
oneview_server_profile{'Server Profile get_sas_logical_jbods':
  ensure => 'get_sas_logical_jbods',
  data   =>
  {
    name     => 'Test Server Profile',
  }
}

# This ensure method is only available for Synergy Hardware
oneview_server_profile{'Server Profile get_sas_logical_jbod_drives':
  ensure => 'get_sas_logical_jbod_drives',
  data   =>
  {
    name     => 'Test Server Profile',
  }
}

# This ensure method is only available for Synergy Hardware
oneview_server_profile{'Server Profile get_sas_logical_jbod_attachments':
  ensure => 'get_sas_logical_jbod_attachments',
  data   =>
  {
    name     => 'Test Server Profile',
  }
}


# To update/modify the server profile name
oneview_server_profile{'Server Profile Edit':
  ensure  => 'present',
  require => Oneview_server_profile['Server Profile Create'],
  data    =>
  {
    name     => 'Test Server Profile',
    new_name => 'Edited Server Profile'
  }
}

# CAUTION: More than one matching server profile can be deleted at once
oneview_server_profile{'Server Profile Destroy':
  ensure  => 'absent',
  require => Oneview_server_profile['Server Profile Edit'],
  data    =>
  {
    name => 'Edited Server Profile'
  }
}

# The server profile must have been created based on a server profile template
# in order to get the compliance preview
# oneview_server_profile{'Server Profile Found':
#   ensure  => 'get_compliance_preview',
#   # require => Oneview_server_profile['Server Profile Create'],
#   data =>
#   {
#     name               => 'Server_Profile_created_from_New SPT #2',
#     # query_parameters =>
#     # {
#     #   count => 1
#     # }
#   }
# }

# If you need to assign a network set, make sure its functionType is 'Set'
# oneview_server_profile{'Server Profile Found':
#   ensure  => 'present',
#   data =>
#   {
#     name  => 'Server_Profile_created_from_New SPT #2',
#     connections =>
#     [
#       {
#         name => 'My Connection',
#         connectionUri => 'My network set'
#         functionType => 'Set',
#       },
#       {
#         name => 'My Connection 2',
#         connectionUri => 'My ethernet'
#         functionType => 'Ethernet',
#       }
#     ]
#   }
# }
