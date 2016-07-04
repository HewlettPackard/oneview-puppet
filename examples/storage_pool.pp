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

oneview_storage_pool{'storage_pool_1':
    ensure => 'present',
    data   => {
      poolName          => "FST_CPG2",
      storageSystemUri  => "/rest/storage-systems/TXQ1000307"
   }
}

oneview_storage_pool{'storage_pool_2':
    ensure => 'found',
    # require => Oneview_storage_pool['storage_pool_1'],
    # This resource accepts a data hash to filter out results or no data hash to display all
    # data   => {
    #   poolName                   => 'FST_CPG2',
    # }
}

oneview_storage_pool{'storage_pool_3':
    ensure => 'absent',
    require => Oneview_storage_pool['storage_pool_2'],
    data   => {
      poolName         => 'FST_CPG2',
    }
}
