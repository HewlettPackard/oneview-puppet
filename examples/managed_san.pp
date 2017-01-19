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

# NOTE 1: The absent state is not available for this resource, as it is
  # created/destroyed by the san manager resource
# NOTE 2: Other than the 'found' method, all methods require an unique identifier
  # for a managed san to be specified
# NOTE 3: The present ensurable cannot create a SAN, it can only update its publicAttributes or
  # sanPolicy tags.

# # This method accepts data as an optional field to filter results
oneview_managed_san{'managed_san_1':
    ensure => 'found',
    # data   => {
    #   name => 'SAN1_0'
    # },
}

# # This requires the SAN to be in a managed state to work
oneview_managed_san{'managed_san_2':
    ensure => 'get_zoning_report',
    data   => {
      name => 'SAN1_0'
    },
}

oneview_managed_san{'managed_san_3':
    ensure => 'get_endpoints',
    data   => {
      name => 'SAN1_0'
    },
}

oneview_managed_san{'managed_san_4':
    ensure => 'set_refresh_state',
    data   => {
      name         => 'SAN1_0',
      refreshState => 'RefreshPending'
    },
}

oneview_managed_san{'managed_san_5':
    ensure => 'present',
    data   => {
      name             => 'SAN1_0',
      publicAttributes => {
        name        => 'MetaSan',
        value       => 'Neon SAN',
        valueType   => 'String',
        valueFormat => 'None'
      },
      sanPolicy        => {
        zoningPolicy          => 'SingleInitiatorAllTargets',
        zoneNameFormat        => '{hostName}_{initiatorWwn}',
        enableAliasing        => true,
        initiatorNameFormat   => '{hostName}_{initiatorWwn}',
        targetNameFormat      => '{storageSystemName}_{targetName}',
        targetGroupNameFormat => '{storageSystemName}_{targetGroupName}'
      }
    }
}
