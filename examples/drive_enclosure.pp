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

# This resource can only be used on Synergy

oneview_drive_enclosure{'Puppet Drive Find':
  ensure => 'found'
}

oneview_drive_enclosure{'Puppet Drive Enclosure Refresh':
    ensure => 'set_refresh_state',
    data   => {
        name         => 'Encl1, bay 1',
        refreshState => 'RefreshPending',
    }
}

oneview_drive_enclosure{'Encl1, bay 1':
  ensure => 'present',
  data   => {
    name  => 'Encl1, bay 1',
    patch =>
    {
    op    => 'replace',
    path  => '/hardResetState',
    value => 'Reset'
    }
  }
}
