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

oneview_fc_network{'fc1':
    ensure => 'present',
    data   => {
      name                    =>  'OneViewSDK Test FC Network',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

oneview_fc_network{'fc2':
    ensure  => 'present',
    require => Oneview_fc_network['fc1'],
    data    => {
      name                    => 'OneViewSDK Test FC Network',
      new_name                => 'Updated OneViewSDK Test FC Network',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

oneview_fc_network{'fc3':
    ensure  => 'found',
    require => Oneview_fc_network['fc2'],
    data    => {
      name                    => 'Updated OneViewSDK Test FC Network',
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

oneview_fc_network{'fc4':
    ensure  => 'absent',
    require => Oneview_fc_network['fc3'],
    data    => {
      name                    => 'Updated OneViewSDK Test FC Network',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

oneview_fc_network{'fc5':
    ensure  => 'found',
    require => Oneview_fc_network['fc4'],
    data    => {
      name                    => 'Updated OneViewSDK Test FC Network',
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}
