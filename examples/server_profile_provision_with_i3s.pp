
# Vars
$server_profile_name = 'Server profile with OS Deployment Plan - PUPPET DEMO'
$server_hardware_name = 'F2-CN7515049D, bay 8'
$server_hardware_type = 'SY 480 Gen9 1'
$network_1 = 'Management'
$network_2 = 'IS iSCSI'
$deployment_plan_name = 'Bootstrap_DCOS'

oneview_server_profile{'Server Profile Creation':
  ensure => 'present',
  data   =>
  {
    name                  => $server_profile_name,
    serverHardwareUri     => $server_hardware_name,
    serverHardwareTypeUri => $server_hardware_type,
    osDeploymentSettings  => {
      osDeploymentPlanUri => $deployment_plan_name
    },
    boot                  => {
      manageBoot => true,
      order      => [ 'HardDisk' ]
    },
    bootMode              => {
      manageMode    => true,
      pxeBootPolicy => 'Auto',
      mode          => 'UEFIOptimized',
    },
    connections           => [
      {
        id            => 1,
        name          => 'connection1',
        functionType  => 'Ethernet',
        networkUri    => $network_1,
        requestedMbps => 2500,
        requestedVFs  => 'Auto',
        boot          => {
          priority            => 'NotBootable',
        }
      },
      {
        id            => 2,
        name          => 'connection2',
        functionType  => 'Ethernet',
        networkUri    => $network_2,
        requestedMbps => 2500,
        requestedVFs  => 'Auto',
        boot          => {
          priority            => 'Primary',
          initiatorNameSource => 'ProfileInitiatorName'
        }
      },
      {
        id            => 3,
        name          => 'connection3',
        functionType  => 'Ethernet',
        networkUri    => $network_2,
        requestedMbps => 2500,
        requestedVFs  => 'Auto',
        boot          => {
          priority            => 'Secondary',
          initiatorNameSource => 'ProfileInitiatorName'
        }
      }
    ]
  }
}

oneview_server_hardware{'Server Hardware Power On':
    ensure => 'set_power_state',
    data   => {
      hostname    => $server_hardware_name,
      power_state => 'on',
    },
}
