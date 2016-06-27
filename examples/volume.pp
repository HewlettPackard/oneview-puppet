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

oneview_volume{'volume_1':
    ensure => 'present',
    # data   => {
    #   name                   => 'ONEVIEW_SDK_TEST_VOLUME_2',
    #   description            => 'Test volume with common creation: Storage System + Storage Pool',
    #   provisioningParameters => {
    #     provisionType     => 'Full',
    #     shareable         => true,
    #     requestedCapacity => 1024 * 1024 * 1024,
    #     storagePoolUri    => '/rest/storage-pools/A42704CB-CB12-447A-B779-6A77ECEEA77D'
    #   }
    # }
}

# oneview_volume{'volume_2':
#     ensure => 'found',
#     # require => Oneview_volume['volume_1'],
#     # data   => {
#     #   provisionType                   => 'Full',
#     # }
# }
# oneview_volume{'volume_3':
#     ensure => 'absent',
#     require => Oneview_volume['volume_2'],
#     data   => {
#       name                   => 'ONEVIEW_SDK_TEST_VOLUME_2',
#       description            => 'Test volume with common creation: Storage System + Storage Pool',
#       provisioningParameters => {
#         provisionType     => 'Full',
#         shareable         => true,
#         requestedCapacity => 1024 * 1024 * 1024,
#         storagePoolUri    => '/rest/storage-pools/A42704CB-CB12-447A-B779-6A77ECEEA77D'
#       }
#     }
# }


#
# oneview_volume{'volume_4':
#     ensure  => 'get_storage_pools',
#     require => Oneview_volume['volume_3'],
#     data    => {
#       credentials => {
#         ip_hostname  => '172.18.11.11',
#       }
#     }
# }
#
# oneview_volume{'volume_5':
#     ensure  => 'get_managed_ports',
#     require => Oneview_volume['volume_4'],
#     data    => {
#       credentials => {
#         ip_hostname  => '172.18.11.11',
#       }
#     }
# }
#
# oneview_volume{'volume_6':
#     ensure  => 'get_host_types',
#     require => Oneview_volume['volume_5'],
#     data    => {
#       credentials => {
#         ip_hostname  => '172.18.11.11',
#       }
#     }
# }
# oneview_volume{'volume_7':
#     ensure  => 'absent',
#     require => Oneview_volume['volume_6'],
#     data    => {
#       credentials => {
#         ip_hostname  => '172.18.11.11',
#       }
#     }
# }
