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

oneview_sas_interconnect{'SAS Interconnect Found All':
  ensure => 'found'
}

oneview_sas_interconnect{'SAS Interconnect Get Types':
  ensure => 'get_types'
}

oneview_sas_interconnect{'SAS Interconnect Set Refresh State':
  ensure => 'set_refresh_state',
  data   => {
    name         => 'Encl1, interconnect 1',
    refreshState => 'RefreshPending'
  }
}

oneview_sas_interconnect{'SAS Interconnect Patch':
  ensure => 'present',
  data   => {
    name  => 'Encl1, interconnect 1',
    patch =>
    {
      op    => 'replace',
      path  => '/uidState',
      value => 'Off'
    }
  }
}
