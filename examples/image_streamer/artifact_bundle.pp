################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

image_streamer_artifact_bundle{'artifact_bundle_1':
  ensure => 'present',
  data   => {
    name        => 'Artifact_Bundle_Puppet',
    description => 'Artifact Bundle with a Plan Script Artifact',
    planScripts => [{
      resourceUri => 'Plan Script Name',
      readOnly    => false
    }]
  }
}

image_streamer_artifact_bundle{'artifact_bundle_2':
  ensure  => 'present',
  require => Image_streamer_artifact_bundle['artifact_bundle_1'],
  data    => {
    name     => 'Artifact_Bundle_Puppet',
    new_name => 'Artifact_Bundle_Puppet_Renamed'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_3':
  ensure  => 'found',
  require => Image_streamer_artifact_bundle['artifact_bundle_2'],
  data    => {
    name     => 'Artifact_Bundle_Puppet_Renamed'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_4':
  ensure => 'present',
  data   => {
    name                 => 'Artifact_Bundle_2_Puppet',
    artifact_bundle_path => 'examples/image_streamer/artifact_bundle.zip',  # can be either an absolute or relative path
    timeout              => 3600  # optionally sets a timeout (in seconds) for the upload
  }
}

image_streamer_artifact_bundle{'artifact_bundle_5':
  ensure  => 'extract',
  require => Image_streamer_artifact_bundle['artifact_bundle_4'],
  data    => {
    name     => 'Artifact_Bundle_2_Puppet'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_6':
  ensure  => 'download',
  require => Image_streamer_artifact_bundle['artifact_bundle_5'],
  data    => {
    name                          => 'Artifact_Bundle_2_Puppet',
    artifact_bundle_download_path => 'examples/image_streamer/artifact_bundle_downloaded.zip',  # can be either an absolute or relative path
    force                         => false  # does not overwrite the file when it already exists
  }
}

image_streamer_artifact_bundle{'artifact_bundle_7':
  ensure  => 'get_backups',
  require => Image_streamer_artifact_bundle['artifact_bundle_6'],
  data    => {
    name => 'Artifact_Bundle_2_Puppet'
  }
}

# WARN: If there are any artifacts existing, they will be removed before the extract operation
image_streamer_artifact_bundle{'artifact_bundle_8':
  ensure  => 'extract_backup',
  require => Image_streamer_artifact_bundle['artifact_bundle_6'],
  data    => {
    deploymentGroupUri => 'OSDS'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_9':
  ensure  => 'create_backup',
  require => Image_streamer_artifact_bundle['artifact_bundle_7'],
  data    => {
    deploymentGroupUri => 'OSDS'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_10':
  ensure  => 'download_backup',
  require => Image_streamer_artifact_bundle['artifact_bundle_9'],
  data    => {
    backup_download_path => 'examples/image_streamer/backup_bundle.zip',  # can be either an absolute or relative path
    force                => false  # does not overwrite the file when it already exists
  }
}

image_streamer_artifact_bundle{'artifact_bundle_11':
  ensure  => 'create_backup_from_file',
  require => Image_streamer_artifact_bundle['artifact_bundle_10'],
  data    => {
    deploymentGroupUri => 'OSDS',
    backup_upload_path => 'examples/image_streamer/ci-backup2017-03-01T17_40_31.628Z.zip',  # can be either an absolute or relative path
    timeout            => 3600  # optionally sets a timeout (in seconds) for the upload
  }
}

image_streamer_artifact_bundle{'artifact_bundle_12':
  ensure  => 'absent',
  require => Image_streamer_artifact_bundle['artifact_bundle_3'],
  data    => {
    name     => 'Artifact_Bundle_Puppet_Renamed'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_13':
  ensure  => 'absent',
  require => Image_streamer_artifact_bundle['artifact_bundle_11'],
  data    => {
    name     => 'Artifact_Bundle_2_Puppet'
  }
}
