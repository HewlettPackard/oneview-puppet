################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

# This example requires:
# - FC networks 'FC01' and 'FC02'
# - Storage system should be added and a volume should be created
# - Enclosure Groups 'e10_encl_group' and 'e11-encl-group'
# - Server Hardware Type 'BL460c Gen9 1'
# - Firmware bundle 'HPE Synergy Custom SPP 201912 2019 12 19' (make 'manageFirmware' as false if firmware is not available)

# You can either declare the name or the uri of the following parameters that require Uri:
oneview_server_profile_template{'Server Profile Template Create':
  ensure => 'present',
  data   =>
    {
      name                  => 'New SPT',
      enclosureGroupUri     => 'enclosureGp',
      serverHardwareTypeUri => 'SY 480 Gen9 1',
      connectionSettings    =>
      {
        manageConnections => true,
        connections       =>
        [
        {
            id           => 3,
            networkUri   => 'FC01',
            functionType => 'FibreChannel'
        },
        {
            id           => 4,
            networkUri   => 'FC02',
            functionType => 'FibreChannel'
        }
        ]
      },
      firmware              =>
      {
        firmwareBaselineUri => 'HPE Synergy Custom SPP 201912 2019 12 19',
        manageFirmware      => true
      },
      boot                  =>
      {
        manageBoot        => true,
        order             =>
        [
        'HardDisk'
        ],
        complianceControl => 'Checked'
      },
      bootMode              =>
      {
        manageMode        => true,
        mode              => 'UEFIOptimized',
        pxeBootPolicy     => 'Auto',
        complianceControl => 'Checked'
      },
      bios                  =>
      {
        manageBios         => true,
        complianceControl  => 'Checked',
        overriddenSettings =>
        [
          { id    => 'UsbControl',
            value => 'UsbEnabled'
          },
          { id    => 'PowerRegulator',
            value => 'StaticHighPerf'
          },
          { id    => 'CollabPowerControl',
            value => 'Disabled'
          },
          { id    => 'EnergyPerfBias',
            value => 'MaxPerf'
          },
          { id    => 'MinProcIdlePkgState',
            value =>'NoState'
          },
          { id    => 'NumaGroupSizeOpt',
            value => 'Clustered'
          },
          { id    => 'MinProcIdlePower',
            value => 'NoCStates'
          }
        ]
      },
      managementProcessor   =>
      {
        complianceControl => 'Checked',
        manageMp          => true,
        mpSettings        =>
        [
          {
            settingType => 'LocalAccounts',
            args        =>
            {
              localAccounts =>
              [
                {
                  userName                 => '<username>',
                  displayName              => '<localuser>',
                  password                 => '<password>',
                  userConfigPriv           => false,
                  remoteConsolePriv        => true,
                  virtualMediaPriv         => true,
                  virtualPowerAndResetPriv => true,
                  iLOConfigPriv            => true
                }
              ]
            }
          }
        ],
      },
      localStorage          =>
      {
        complianceControl => 'Checked',
        controllers       =>
        [
          {
            deviceSlot    => 'Embedded',
            mode          => 'RAID',
            initialize    => false,
            logicalDrives =>
            [
            {
            name              => 'Operating System',
            raidLevel         => 'RAID1',
            bootable          => true,
            numPhysicalDrives => 2,
            driveTechnology   => '',
            sasLogicalJBODId  => '',
            }
            ]
          }
        ]
      },
      sanStorage            =>
      {
        complianceControl => 'Checked',
        manageSanStorage  => true,
        hostOSType        => 'VMware (ESXi)',
        volumeAttachments =>
        [
          {
            id                             => 1,
            associatedTemplateAttachmentId => 'c9b33747-7f2e-485b-8840-7334a824510f',
            lun                            => '',
            lunType                        => 'Auto',
            storagePaths                   =>
            [
              {
                connectionId   => 4,
                isEnabled      => true,
                targetSelector => 'Auto'
              },
              {
                connectionId   => 3,
                isEnabled      => true,
                targetSelector => 'Auto'
              }
            ],
            volumeUri                      => '/rest/storage-volumes/16ADC014-7799-4814-9962-A93C0143BC68',
            volume                         => {},
            volumeStorageSystemUri         => '/rest/storage-systems/MXN6122CVA',
            bootVolumePriority             => 'NotBootable'
          },
          {
            id                             => 2,
            associatedTemplateAttachmentId => '4e620feb-742e-4ba1-bb01-2b7625c74c08',
            lun                            => '',
            lunType                        => 'Auto',
            storagePaths                   =>
            [
              {
                connectionId   => 3,
                isEnabled      => true,
                targetSelector => 'Auto'
              },
              {
                connectionId   => 4,
                isEnabled      => true,
                targetSelector => 'Auto'
              }
            ],
            volumeUri                      => '/rest/storage-volumes/B9981C13-EED1-4F21-B95F-A93D00D23E3F',
            volume                         => {},
            volumeStorageSystemUri         => '/rest/storage-systems/MXN6122CVA',
            bootVolumePriority             => 'NotBootable'
          }
          ]
      }
    }
}

oneview_server_profile_template{'Server Profile Template Found':
  ensure  => 'found',
  require => Oneview_server_profile_template['Server Profile Template Create'],
  data    =>
    {
      name => 'New SPT',
    }
}

oneview_server_profile_template{'Server Profile Template Edit':
  ensure  => 'present',
  require => Oneview_server_profile_template['Server Profile Template Found'],
  data    =>
    {
      name     => 'New SPT',
      new_name => 'Update SPT'
    }
}

oneview_server_profile_template{'Server Profile Template Create #2':
  ensure  => 'present',
  require => Oneview_server_profile_template['Server Profile Template Edit'],
  data    =>
    {
      name                  => 'New SPT #2',
      enclosureGroupUri     => 'enclosureGp',
      serverHardwareTypeUri => 'SY 480 Gen9 1'
    }
}

oneview_server_profile_template{'Server Profile Template Get All':
  ensure  => 'found',
  require => Oneview_server_profile_template['Server Profile Template Create #2'],
  data    =>
    {
      name => 'New SPT #2'
    }
}

oneview_server_profile_template{'Server Profile Template Destroy':
  ensure  => 'absent',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name => 'Update SPT',
    }
}

# The server profile name is optional; a default name will be provided
oneview_server_profile_template{'Server Profile Create':
  ensure  => 'set_new_profile',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name                  => 'New SPT #2',
      # serverProfileName     => 'My SP'
    }
}

oneview_server_profile_template{'Get Transformation':
  ensure  => 'get_transformation',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name            => 'New SPT #2',
      queryParameters => {
        enclosureGroupUri     => 'enclosureGp',
        serverHardwareTypeUri => 'SY 480 Gen9 1'
      }
    }
}
oneview_server_profile_template{'Get Available Networks':
  ensure  => 'get_available_networks',
  require => Oneview_server_profile_template['Server Profile Template Get All'],
  data    =>
    {
      name            => 'New SPT #2',
      queryParameters => {
        enclosureGroupUri     => 'enclosureGp',
        serverHardwareTypeUri => 'SY 480 Gen9 1'
      }
    }
}

# This task will work only after deleting the above created Server Profile
# oneview_server_profile_template{'Server Profile Template Destroy #2':
#   ensure  => 'absent',
#   require => Oneview_server_profile_template['Server Profile Create'],
#   data    =>
#     {
#       name => 'New SPT #2',
#     }
# }
