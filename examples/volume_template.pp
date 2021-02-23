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

# Below request body is for creation for API500 and above. Refer API docs for other versions.
oneview_volume_template{'volume_template_1':
    ensure => 'present',
    data   => {
      'name'             => 'ONEVIEW_PUPPET_TEST',
      'description'      => 'Test volume template for puppet',
      'rootTemplateUri'  => '',
      'properties'       => {
          'name'             => {
              'title'       => 'Volume name',
              'description' => 'A volume name between 1 and 100 characters',
              'minLength'   => 1,
              'maxLength'   => 100,
              'type'        => 'string',
              'required'    => true,
              'meta'        => {
                  'locked'   => false
              }
          },
          'description'      => {
              'title'       => 'Description',
              'default'     => '',
              'required'    => false,
              'description' => 'A description for the volume',
              'type'        => 'string',
              'minLength'   => 0,
              'maxLength'   => 2000,
              'meta'        => {
                  'locked'  => false
              }
          },
          'storagePool'      => {
              'title'       => 'Storage Pool',
              'description' => 'A common provisioning group URI reference',
              'type'        => 'string',
              'format'      => 'x-uri-reference',
              'default'     => '',
              'required'    => true,
              'meta'        => {
                  'locked'       => false,
                  'createOnly'   => true,
                  'semanticType' => 'device-storage-pool'
                  }
          },
          'snapshotPool'     => {
              'type'        => 'string',
              'title'       => 'Snapshot Pool',
              'description' => 'A URI reference to the common provisioning group used to create snapshots',
              'format'      => 'x-uri-reference',
              'default'     => '',
              'meta'        => {
                  'locked'       => true,
                  'semanticType' => 'device-snapshot-storage-pool'
              }
          },
          'size'             => {
              'title'       => 'Capacity',
              'description' => 'The capacity of the volume in bytes',
              'type'        => 'integer',
              'minimum'     => 268435456,
              'maximum'     => 17592186044416,
              'default'     => 1073741824,
              'required'    => true,
              'meta'        => {
                  'locked'       => false,
                  'semanticType' => 'capacity'
              }
          },
          'provisioningType' => {
              'title'       => 'Provisioning Type',
              'description' => 'The provisioning type for the volume',
              'type'        => 'string',
              'enum'        => [
                  'Thin',
                  'Full'
              ],
              'default'     => 'Full',
              'meta'        => {
                  'locked'     => false,
                  'createOnly' => true
              }
          },
          'isShareable'      => {
              'title'       => 'Is Shareable',
              'description' => 'The shareability of the volume',
              'type'        => 'boolean',
              'default'     => false,
              'meta'        => {
                  'locked'   => false
              }
          }
      }
    }
}

oneview_volume_template{'volume_template_2':
    ensure  => 'present',
    require => Oneview_volume_template['volume_template_1'],
    data    => {
      name        => 'ONEVIEW_PUPPET_TEST',
      new_name    => 'ONEVIEW_PUPPET_TEST VT1',
      description => 'Volume Template after update',
    }
}

# This resource accepts a data hash to filter out results or no data hash to display all
oneview_volume_template{'volume_template_3':
    ensure  => 'found',
    require => Oneview_volume_template['volume_template_2'],
    data    => {
      name        => 'ONEVIEW_PUPPET_TEST VT1'
    }
}

# Method unavailable for api500 and above
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

# Method available from api500 and above
oneview_volume_template{'volume_template_5':
    ensure  => 'get_compatible_systems',
    require => Oneview_volume_template['volume_template_3'],
    data    => {
      name                   => 'ONEVIEW_PUPPET_TEST VT1',
    }
}

# Method available from api500 and above
oneview_volume_template{'volume_template_6':
    ensure  => 'get_reachable_volume_templates',
    require => Oneview_volume_template['volume_template_3'],
    data    => {
      name             => 'ONEVIEW_PUPPET_TEST VT1',
      query_parameters => {
        scopeUris => ''
      }
    }
}

oneview_volume_template{'volume_template_7':
    ensure  => 'absent',
    require => Oneview_volume_template['volume_template_3'],
    data    => {
      name => 'ONEVIEW_PUPPET_TEST VT1',
    }
}
