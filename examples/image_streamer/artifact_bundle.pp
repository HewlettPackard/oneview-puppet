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
    artifact_bundle_path => 'examples/image_streamer/artifact_bundle.zip'  # can be either an absolute or relative path
  }
}

image_streamer_artifact_bundle{'artifact_bundle_5':
  ensure  => 'absent',
  require => Image_streamer_artifact_bundle['artifact_bundle_3'],
  data    => {
    name     => 'Artifact_Bundle_Puppet_Renamed'
  }
}

image_streamer_artifact_bundle{'artifact_bundle_6':
  ensure  => 'absent',
  require => Image_streamer_artifact_bundle['artifact_bundle_4'],
  data    => {
    name     => 'Artifact_Bundle_2_Puppet'
  }
}
