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
# oneview_logical_enclosure{'logical_enc0':
#     ensure  => 'present',
#     data    => {
#       name                      =>  'one_enclosure_le',
#       enclosureUris             =>  'rest/enclosures/09SGH100X6J1',
#       enclosureGroupUri         =>  '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#       firmwareBaselineUri       =>  'null',
#       forceInstallFirmware       =>  'false',
#     }
# }

oneview_logical_enclosure{'logical_enc1':
    ensure => 'get_script',
    data   => {
      name                      =>  'Encl1',
    }
}

oneview_logical_enclosure{'logical_enc2':
    ensure => 'set_script',
    data   => {
      name   =>  'Encl1',
      script =>  'This is a script example',
    }
}

oneview_logical_enclosure{'logical_enc3':
    ensure => 'get_script',
    data   => {
      name                      =>  'Encl1',
    }
}

oneview_logical_enclosure{'logical_enc4':
    ensure => 'updated_from_group',
    data   => {
      name                      =>  'Encl1',
    }
}

oneview_logical_enclosure{'logical_enc5':
    ensure => 'dumped',
    data   => {
      name =>  'Encl1',
      dump =>
        {
          errorCode            => 'Mydump',
          encrypt              => false,
          excludeApplianceDump => false
        }
    }
}
