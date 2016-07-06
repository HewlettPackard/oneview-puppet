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

oneview_volume_attachment{'volume_attachment_1':
    ensure => 'present',
    # This method is actually unavailable and will not run
}

oneview_volume_attachment{'volume_attachment_2':
    ensure  => 'absent',
    require => Oneview_volume_attachment['volume_attachment_1'],
    # This method is actually unavailable and will not run
}

oneview_volume_attachment{'volume_attachment_3':
    ensure  => 'found',
    require => Oneview_volume_attachment['volume_attachment_2'],
    # This resource accepts a data hash to filter out results or no data hash to display all
    # data   => {
    #   name                   => 'ONEVIEW_PUPPET_TEST VA1',
    # }
}

oneview_volume_attachment{'volume_attachment_4':
    ensure  => 'get_extra_unmanaged_volumes',
    require => Oneview_volume_attachment['volume_attachment_3'],
    data    => {
      name       => 'ONEVIEW_PUPPET_TEST VA1',
    }
}

oneview_volume_attachment{'volume_attachment_5':
    ensure => 'remove_extra_unmanaged_volume',
    data   => {
      name       => 'OneViewSDK Test ServerProfile1',
    }
}

oneview_volume_attachment{'volume_attachment_6':
    ensure => 'get_paths',
    data   => {
      name       => 'ONEVIEW_PUPPET_TEST VA1',
    }
}
