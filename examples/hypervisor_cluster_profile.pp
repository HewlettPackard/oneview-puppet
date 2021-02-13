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
# NOTE: As a pre-requisite, create a Server Profile Template and add a hypervisor manager.

# This created Hypervisor ClusterProfile if we use ServerProfileTemplate without OS DeploymentPlan
oneview_hypervisor_cluster_profile{'hcp1 Create':
    ensure => 'present',
    data   => {
      type                          => 'HypervisorClusterProfileV4',
      name                          => 'Cluster5',
      hypervisorManagerUri          => '',
      path                          => 'DC2',
      hypervisorType                => 'Vmware',
      hypervisorHostProfileTemplate => {
      serverProfileTemplateUri => '',
      hostprefix               => 'Test-Cluster-host'
      }
    }
}

# This creates Hypervisor Cluster Profile using Server Profile Template with OSDeploymentPlan
oneview_hypervisor_cluster_profile{'hcp2 Create':
    ensure  => 'present',
    require => Oneview_hypervisor_cluster_profile['hcp1 Create'],
    data    => {
      type                          => 'HypervisorClusterProfileV4',
      name                          => 'Cluster10',
      hypervisorManagerUri          => '',
      path                          => 'DC2',
      hypervisorType                => 'Vmware',
      hypervisorHostProfileTemplate => {
        serverProfileTemplateUri => '',
        deploymentPlan           => {
          deploymentPlanUri => '',
          serverPassword    => '<server-password>'
        },
        hostprefix               => 'Test-Cluster-host-10'
      }
    }
}

oneview_hypervisor_cluster_profile{'hcp3 Update':
    ensure  => 'present',
    require => Oneview_hypervisor_cluster_profile['hcp2 Create'],
    data    => {
      name     => 'Cluster5',
      new_name => 'Cluster6',
    }
}

oneview_hypervisor_cluster_profile{'hcp4 Found':
    ensure  => 'found',
    require => Oneview_hypervisor_cluster_profile['hcp3 Update'],
    data    => {
      name => 'Cluster6'
    }
}

# In API1600, delete method accepts 2 arguments - soft_delete(boolean) and force(boolean)
# NOTE: Till API1200, delete method don't accept any arguments
oneview_hypervisor_cluster_profile{'hcp5 Delete':
    ensure  => 'absent',
    require => Oneview_hypervisor_cluster_profile['hcp4 Found'],
    data    => {
      name        => 'Cluster6',
      soft_delete => true,
      force       => true
    }
}
