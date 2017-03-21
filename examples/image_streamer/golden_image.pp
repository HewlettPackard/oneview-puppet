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

image_streamer_golden_image{'golden_image_1':
  ensure => 'present',
  data   => {
    name         => 'Golden_Image_1',
    description  => 'Golden Image created from the deployed OS Volume',
    imageCapture => true,
    osVolumeURI  => 'OSVolume-1',
    buildPlanUri => 'Build Plan Name'
  }
}

image_streamer_golden_image{'golden_image_2':
  ensure => 'present',
  data   => {
    name              => 'Golden_Image_2',
    description       => 'Golden image added from the file that is uploaded from a local drive',
    golden_image_path => 'golden_image.zip',  # can be either an absolute or relative path
    timeout           => 3600  # you can set a timeout (in seconds) for the upload
  }
}

image_streamer_golden_image{'golden_image_3':
  ensure => 'present',
  data   => {
    name        => 'Golden_Image_2',
    description => 'Golden image renamed'
  }
}

image_streamer_golden_image{'golden_image_4':
  ensure  => 'found',
  require => Image_streamer_golden_image['golden_image_3'],
  data    => {
    name => 'Golden_Image_2'
  }
}

image_streamer_golden_image{'golden_image_5':
  ensure  => 'download_details_archive',
  require => Image_streamer_golden_image['golden_image_4'],
  data    => {
    name                 => 'Golden_Image_2',
    details_archive_path => 'log_archive.zip'  # can be either an absolute or relative path
  }
}

image_streamer_golden_image{'golden_image_6':
  ensure  => 'download',
  require => Image_streamer_golden_image['golden_image_5'],
  data    => {
    name                       => 'Golden_Image_2',
    golden_image_download_path => 'golden_image.zip',  # can be either an absolute or relative path
  }
}

image_streamer_golden_image{'golden_image_7':
  ensure  => 'absent',
  require => Image_streamer_golden_image['golden_image_6'],
  data    => {
    name => 'Golden_Image_2'
  }
}

image_streamer_golden_image{'golden_image_8':
  ensure  => 'absent',
  require => Image_streamer_golden_image['golden_image_1'],
  data    => {
    name => 'Golden_Image_1'
  }
}
