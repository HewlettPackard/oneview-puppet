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

# This example requires:
# - Enclosure Groups 'e10_encl_group' and 'e11-encl-group'
# - Server Hardware Type 'BL460c Gen9 1'

# You can either declare the name or the uri of the following parameters that require Uri:
oneview_server_profile_template{'Server Profile Template Create':
  ensure => 'present',
  data   =>
    {
      name                  => 'New SPT',
      enclosureGroupUri     => 'e10_encl_group',
      serverHardwareTypeUri => 'BL460c Gen9 1',
      # connections =>
      # [
      #   {
      #     networkUri => 'Ethernet 1',
      #     functionType => 'Ethernet'
      #   }
      # ]
      # firmware =>
      # {
      #   firmwareBaselineUri => 'FW Baseline Name',
      #   manageFirmware      => true
      # }
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
      new_name => 'Update SPT'
    }
}

oneview_server_profile_template{'Server Profile Template Create #2':
  ensure  => 'present',
  require => Oneview_server_profile_template['Server Profile Template Edit'],
  data    =>
    {
      name                  => 'New SPT #2',
      enclosureGroupUri     => 'e10_encl_group',
      serverHardwareTypeUri => 'BL460c Gen9 1'
    }
}

oneview_server_profile_template{'Server Profile Template Get All':
  ensure  => 'found',
  require => Oneview_server_profile_template['Server Profile Template Create #2'],
  data    =>
    {
      name => 'New SPT #2'
    }
}

oneview_server_profile_template{'Server Profile Template Destroy':
  ensure  => 'absent',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name => 'Update SPT',
    }
}

# The server profile name is optional; a default name will be provided
oneview_server_profile_template{'Server Profile Create':
  ensure  => 'set_new_profile',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name                  => 'New SPT #2',
      # serverProfileName     => 'My SP'
    }
}

oneview_server_profile_template{'Get Transformation':
  ensure  => 'get_transformation',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name            => 'New SPT #2',
      queryParameters => {
        enclosureGroupUri     => 'e11-encl-group',
        serverHardwareTypeUri => 'BL460c Gen9 1'
      }
    }
}
oneview_server_profile_template{'Get Available Networks':
  ensure  => 'get_available_networks',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name            => 'New SPT #2',
      queryParameters => {
        enclosureGroupUri     => 'e11-encl-group',
        serverHardwareTypeUri => 'BL460c Gen9 1'
      }
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
