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

/*   Infrastructure Provisioning without Image Stramear
	Be able to provision compute (with server settings), networking, and storage.
	Create a server profile template with the following options:
		Network connections
    Firmware
		Boot mode
		Boot settings
    iLo settings
    Local Storage/SAN Storage
		Create a server profile from a server profile template and assign to hardware
*/

# You can either declare the name or the uri of the following parameters that require Uri:
oneview_server_profile_template{'Server Profile Template Create':
  ensure => 'present',
  data   =>
    {
      name                  => 'SPT-puppet-demo',
      enclosureGroupUri     => 'SYN03_EC',
      serverHardwareTypeUri => 'SY 480 Gen9 3',
      connectionSettings =>
      {
        manageConnections  => true,
        connections =>
        [
         {
            id => 3,
            networkUri => 'FC01',
            functionType => 'FibreChannel'
          },
          {
             id => 4,
             networkUri => 'FC02',
             functionType => 'FibreChannel'
          }
        ]
      },
      firmware =>
      {
        firmwareBaselineUri => 'HPE Synergy Custom SPP 201912 2019 12 19',
        manageFirmware      => true
      },
      boot =>
      {
        manageBoot => true,
        order =>
        [
         'HardDisk'
        ],
        complianceControl => 'Checked'
      },
      bootMode =>
      {
        manageMode => true,
        mode => 'UEFIOptimized',
        pxeBootPolicy => 'Auto',
        complianceControl => 'Checked'
      },
      bios =>
      {
        manageBios => true,
        complianceControl => 'Checked',
        overriddenSettings =>
        [
          { id => 'UsbControl',
            value => 'UsbEnabled'
          },
          { id => 'PowerRegulator',
            value => 'StaticHighPerf'
          },
          { id => 'CollabPowerControl',
            value => 'Disabled'
          },
          { id => 'EnergyPerfBias',
            value => 'MaxPerf'
          },
          { id => 'MinProcIdlePkgState',
            value =>'NoState'
          },
          { id => 'NumaGroupSizeOpt',
            value => 'Clustered'
          },
          { id => 'MinProcIdlePower',
            value => 'NoCStates'
          }
        ]
      },
      managementProcessor =>
      {
        complianceControl => 'Checked',
        manageMp => true,
        mpSettings =>
        [
          {
            settingType => 'LocalAccounts',
            args =>
            {
              localAccounts =>
              [
                {
                  userName => 'user1',
                  displayName => 'localuser',
                  password => 'localuser',
                  userConfigPriv => false,
                  remoteConsolePriv => true,
                  virtualMediaPriv => true,
                  virtualPowerAndResetPriv => true,
                  iLOConfigPriv => true
                }
              ]
            }
          }
        ],
      },
      localStorage =>
      {
        complianceControl => 'Checked',
        controllers =>
        [
          {
            deviceSlot => 'Embedded',
            mode => 'RAID',
            initialize => false,
            logicalDrives =>
            [
             {
               name => 'Operating System',
               raidLevel => 'RAID1',
               bootable => true,
               numPhysicalDrives => 2,
               driveTechnology => '',
               sasLogicalJBODId => '',
             }
            ]
          }
        ]
      },
      sanStorage =>
      {
        complianceControl => 'Checked',
        manageSanStorage => true,
        hostOSType => 'VMware (ESXi)',
        volumeAttachments =>
        [
          {
            id => 1,
            associatedTemplateAttachmentId => 'c9b33747-7f2e-485b-8840-7334a824510f',
            lun => '',
            lunType => 'Auto',
            storagePaths =>
            [
              {
                connectionId => 4,
                isEnabled => true,
                targetSelector => 'Auto'
              },
              {
                connectionId => 3,
                isEnabled => true,
                targetSelector => 'Auto'
              }
            ],
            volumeUri => '/rest/storage-volumes/16ADC014-7799-4814-9962-A93C0143BC68',
            volume => {},
            volumeStorageSystemUri => '/rest/storage-systems/MXN6122CVA',
            bootVolumePriority => 'NotBootable'
          },
          {
            id => 2,
            associatedTemplateAttachmentId => '4e620feb-742e-4ba1-bb01-2b7625c74c08',
            lun => '',
            lunType => 'Auto',
            storagePaths =>
            [
              {
                connectionId => 3,
                isEnabled => true,
                targetSelector => 'Auto'
              },
              {
                connectionId => 4,
                isEnabled => true,
                targetSelector => 'Auto'
              }
            ],
            volumeUri => '/rest/storage-volumes/B9981C13-EED1-4F21-B95F-A93D00D23E3F',
            volume => {},
            volumeStorageSystemUri => '/rest/storage-systems/MXN6122CVA',
            bootVolumePriority => 'NotBootable'
          }
         ]
      }

    }
}
# The server profile name is optional; a default name will be provided
/*
oneview_server_profile_template{'Server Profile Create':
  ensure  => 'set_new_profile',
  require => Oneview_server_profile_template['Server Profile Template Create'],
  data    =>
    {
      name                  => 'SPT-puppet-demo',
      serverProfileName     => 'My SP'
    }
}
*/
