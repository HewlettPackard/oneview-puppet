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

# NOTE: The snapshot actions use the 'snapshotParameters' tag to pass in the snapshot parameters.
  # it should be passed in as a hash inside data with the attributes wanted.
# NOTE2: The get_snapshot ensurable accepts a snapshotParameters hash to filter out results or
  # no hash to display all results


oneview_volume{'volume_1':
    ensure => 'present',
    data   => {
      properties  => {
            provisioningType => 'Thin',
            size             => 1073741824,
            name             => 'Oneview_Puppet_TEST_VOLUME_1',
            storagePool      => '/rest/storage-pools/97BC0F4F-3706-496E-B7A1-A8D90065D7E0',
            isShareable      => false
      },
      templateUri => '/rest/storage-volume-templates/33c731e6-cc0f-4c47-bf9c-a8f6004f6076',
    }
}

oneview_volume{'volume_2':
    ensure  => 'create_snapshot',
    require => Oneview_volume['volume_1'],
    data    => {
      name               => 'Oneview_Puppet_TEST_VOLUME_1',
      snapshotParameters => {
              name        => 'test_snapshot',
              type        => 'Snapshot',
              description => 'New snapshot',
      }
    }
}

oneview_volume{'volume_3':
    ensure  => 'get_snapshot',
    require => Oneview_volume['volume_2'],
    data    => {
      name               => 'Oneview_Puppet_TEST_VOLUME_1',
      snapshotParameters => {
        name     => 'test_snapshot',
      }
    }
}

oneview_volume{'volume_4':
    ensure  => 'found',
    require => Oneview_volume['volume_3'],
    # data   => {
    #   provisionType                   => 'Full',
    # }
}

oneview_volume{'volume_5':
    ensure  => 'get_attachable_volumes',
    require => Oneview_volume['volume_4'],
    data    => {
      query_parameters  => {
        connections    => "[{'networkUri':'/rest/fc-networks/90bd0f63-3aab-49e2-a45f-a52500b46616','proxyName':'20:19:50:EB:1A:0F:0E:B6','initiatorName':'10:00:62:01:F8:70:00:0E'}]"
      }
    }
}

oneview_volume{'volume_6':
    ensure  => 'get_extra_managed_volume_paths',
    require => Oneview_volume['volume_5']
}


oneview_volume{'volume_7':
    ensure => 'repair',
    data   => {
      name                   => 'Oneview_Puppet_TEST_VOLUME_1',
    }
}

oneview_volume{'volume_8':
    ensure  => 'delete_snapshot',
    require => Oneview_volume['volume_6'],
    data    => {
      name               => 'Oneview_Puppet_TEST_VOLUME_1',
      snapshotParameters => {
                name     => 'test_snapshot',
      }
    }
}

oneview_volume{'volume_10':
    ensure  => 'absent',
    require => Oneview_volume['volume_8'],
    data    => {
      name                   => 'Oneview_Puppet_TEST_VOLUME_1',
    }
}
