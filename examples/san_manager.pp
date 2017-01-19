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

# NOTE: Other than the 'found' method, all methods require an unique identifier
  # for a san manager to be specified

oneview_san_manager{'san_manager_1':
    ensure => 'present',
    data   => {
      providerUri    => 'Brocade Network Advisor',
      connectionInfo => [
      {
        name  => 'Host',
        value => '172.18.15.1'
      },
      {
        name  => 'Port',
        value => 5989
      },
      {
        name  => 'Username',
        value => 'dcs'
      },
      {
        name  => 'Password',
        value => 'dcs'
      },
      {
        name  => 'UseSsl',
        value => true
      }
      ],
    },
}

oneview_san_manager{'san_manager_2':
    ensure => 'present',
    data   => {
      providerUri  => 'Brocade Network Advisor',
      refreshState => 'RefreshPending',
    },
}

# This method accepts data as an optional field to filter results
oneview_san_manager{'san_manager_3':
    ensure => 'found',
    data   => {
      # providerDisplayName => 'Brocade Network Advisor',
    },
}

oneview_san_manager{'san_manager_4':
    ensure => 'absent',
    data   => {
      providerUri => 'Brocade Network Advisor'
    },
}
