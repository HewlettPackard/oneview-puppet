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

# This example demonstrates how to create an advanced Gen 9 profile with OS Deployment Settings.
#
# The Artifact Bundle Zip file contains a Golden Image, Build Plans, Plan Scripts, and a Deployment Plan.
# The Deployment Plan will provision an OS Image that is not really an OS but rather a very minimal
# OS Volume having only UEFI boot loader content in a UEFI Extended System Partition.
# It has a simple configuration to show a message on the server console at boot.
#
# Once this manifest is run, the following actions must be taken:
#  1. Launch server console
#  2. Power on and boot the server
#  3. Wait for the server to boot

$file_path = 'examples/image_streamer/files/artifact-bundle-dev.zip'

image_streamer_artifact_bundle{'artifact_bundle_present':
  ensure => 'present',
  data   => {
    name                 => 'Artifact_Bundle_Example',
    artifact_bundle_path => $file_path
  }
}

image_streamer_artifact_bundle{'artifact_bundle_extracted':
  ensure  => 'extract',
  require => Image_streamer_artifact_bundle['artifact_bundle_present'],
  data    => {
    name     => 'Artifact_Bundle_Example'
  }
}

image_streamer_deployment_plan{'deployment_plan_found':
  ensure  => 'found',
  require => Image_streamer_artifact_bundle['artifact_bundle_extracted'],
  data    => {
    name     => 'HPE - Developer 1.0 - Deployment Test (UEFI)'
  }
}

oneview_server_profile{'server_profile_present':
  ensure  => 'present',
  require => Image_streamer_artifact_bundle['artifact_bundle_extracted'],
  data    =>
  {
    name                  => 'Puppet Server Profile',
    serverHardwareTypeUri => 'SY 480 Gen9 1',
    enclosureGroupUri     => 'EG',
    enclosureBay          => 2,
    affinity              => 'BayAndServer',
    enclosureUri          => 'SGH537YCES',
    osDeploymentSettings  => {
      osDeploymentPlanUri => 'HPE - Developer 1.0 - Deployment Test (UEFI)'
    },
    bootMode              => {
      manageMode    => true,
      mode          => 'UEFIOptimized',
      pxeBootPolicy => 'Auto'
    },
    connections           => [{
      id            => 1,
      name          => 'deploy-network',
      functionType  => 'Ethernet',
      networkUri    => 'deploy',
      requestedMbps => 2500,
      requestedVFs  => 'Auto',
      boot          => {
        priority            => 'Primary',
        initiatorNameSource => 'ProfileInitiatorName'
      }
    }, {
      id            => 2,
      name          => 'corp',
      functionType  => 'Ethernet',
      networkUri    => 'mgmt',
      requestedMbps => 2500,
      requestedVFs  => 'Auto'
    }]
  }
}
