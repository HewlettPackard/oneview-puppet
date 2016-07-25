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

oneview_datacenter{'Datacenter Add':
  ensure => 'present',
  data   =>
  {
    name  => 'Datacenter 1',
    width => '4000',
    depth => '4000'
  }
}

oneview_datacenter{'Datacenter Edit':
  ensure  => 'present',
  require => Oneview_datacenter['Datacenter Add'],
  data    =>
  {
    name     => 'Datacenter 1',
    new_name => 'Edited Datacenter',
    width    => '5000',
    depth    => '5000'
  }
}

oneview_datacenter{'Datacenter Get Visual Content':
  ensure  => 'get_visual_content',
  require => Oneview_datacenter['Datacenter Edit'],
  data    =>
  {
    name => 'Edited Datacenter'
  }
}

oneview_datacenter{'Datacenter Remove':
  ensure  => 'absent',
  require => Oneview_datacenter['Datacenter Get Visual Content'],
  data    =>
  {
    name => 'Edited Datacenter'
  }
}

oneview_datacenter{'Datacenter Get All':
  ensure  => 'get_datacenters'
  # Optional filters
  # data    =>
  # {
  #   name => 'Edited Datacenter'
  # }
}
