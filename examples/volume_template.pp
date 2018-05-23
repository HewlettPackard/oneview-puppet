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

oneview_volume_template{'volume_template_1':
    ensure => 'present',
    data   => {
                'name'         => 'ONEVIEW_PUPPET_TEST',
                'description'  => 'Volume Template',
                'type'         => 'StorageVolumeTemplateV3',
                'stateReason'  => 'None',
                'provisioning' => {
                  'shareable'      => true,
                  'provisionType'  => 'Thin',
                  'capacity'       => '235834383322',
                  'storagePoolUri' => 'FST_CPG1'
                }
              }
}

oneview_volume_template{'volume_template_2':
    ensure  => 'present',
    require => Oneview_volume_template['volume_template_1'],
    data    => {
      name        => 'ONEVIEW_PUPPET_TEST',
      new_name    => 'ONEVIEW_PUPPET_TEST VT1',
      type        => 'StorageVolumeTemplateV3',
      description => 'Volume Template after update',
                    }
}

# This resource accepts a data hash to filter out results or no data hash to display all
oneview_volume_template{'volume_template_3':
    ensure  => 'found',
    require => Oneview_volume_template['volume_template_2'],
    # data   => {
    #   name                   => 'ONEVIEW_PUPPET_TEST VT1',
    # }
}

# This ensurable accepts a tag query_parameters with type hash, containing the filters to the get
oneview_volume_template{'volume_template_4':
    ensure  => 'get_connectable_volume_templates',
    require => Oneview_volume_template['volume_template_3'],
    data    => {
      name             => 'ONEVIEW_PUPPET_TEST VT1',
      query_parameters => {
        count => '5',
        start => '0'
      }
    }
}

oneview_volume_template{'volume_template_5':
    ensure  => 'absent',
    require => Oneview_volume_template['volume_template_4'],
    data    => {
      name => 'ONEVIEW_PUPPET_TEST VT1',
    }
}
