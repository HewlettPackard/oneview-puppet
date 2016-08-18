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

# This example requires:
# A server hardware '172.18.6.15'

# Some get endpoints accept query parameters. Please check the API reference for more
# information on which filters can be used

oneview_server_profile{'Server Profile Get Available Targets':
  ensure => 'get_available_targets'
}

oneview_server_profile{'Server Profile Create':
  ensure  => 'present',
  require => Oneview_server_profile['Server Profile Get Available Targets'],
  data    =>
  {
    name              => 'Test Server Profile',
    type              => 'ServerProfileV5',
    serverHardwareUri => '172.18.6.15',
  }
}

# Optional filters
oneview_server_profile{'Server Profile Found':
  ensure  => 'found',
  require => Oneview_server_profile['Server Profile Create'],
  # data    =>
  # {
  #   name => 'Test Server Profile'
  # }
}

oneview_server_profile{'Server Profile Edit':
  ensure  => 'present',
  require => Oneview_server_profile['Server Profile Found'],
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
#         name => 'My Network Set',
#         functionType => 'Set',
#       },
#       {
#         name => 'Ethernet Network 1',
#         functionType => 'Ethernet',
#       }
#     ]
#   }
# }

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
#
