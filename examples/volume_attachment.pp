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

# NOTE: The 'present' and 'absent' ensurables are disabled for this resource
  # as it is created/updated/deleted through other resources/dependencies.
# NOTE2: The 'found' ensurable for this resource accepts either no data declared to find all
  # volume attachments, or a 'Server Profile name, Volume name' combination to get information on the specified
  # storage volume attachment. This second method is the recommended way to find out the 'id' for a storage attachment

oneview_volume_attachment{'volume_attachment_3':
    ensure => 'found',
    data   => {
      name                   => 'Server Profile Attachment Demo, volume-attachment-demo',
    }
}

# This resource does not require a data hash as it will return all extra unmanaged volumes.
oneview_volume_attachment{'volume_attachment_4':
    ensure  => 'get_extra_unmanaged_volumes',
    require => Oneview_volume_attachment['volume_attachment_3'],
    # data    => {
    #   name       => 'ONEVIEW_PUPPET_TEST VA1',
    # }
}

# This requires the name of the server profile from which to remove the Volume Attachments
oneview_volume_attachment{'volume_attachment_5':
    ensure => 'remove_extra_unmanaged_volume',
    data   => {
      name       => 'OneViewSDK Test ServerProfile1',
    }
}

# get_paths requires the volume attachment name and accepts the path id to filter out,
  # or displays all paths within the volume attachment
oneview_volume_attachment{'volume_attachment_6':
    ensure => 'get_paths',
    data   => {
      name       => 'ONEVIEW_PUPPET_TEST VA1',
    }
}
