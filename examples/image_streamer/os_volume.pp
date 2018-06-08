################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

# NOTE: As with all resources, the found ensurable accepts a data as an optional filter field.

image_streamer_os_volume{'os_volume_1':
    ensure => 'found',
    data   => {
      name        => 'OSVolume-42'
    }
}
#
image_streamer_os_volume{'os_volume_2':
    ensure  => 'get_details_archive',
    data    => {
      name     => 'OSVolume-42'
    }
}

image_streamer_os_volume{'os_volume_storage':
    ensure  => 'get_os_volumes_storage',
    data    => {
      name     => 'OSVolume-42'
    }
}
