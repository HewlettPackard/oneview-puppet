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

oneview_unmanaged_device{'Unmanaged Device Add':
  ensure => 'present',
  data   =>
  {
    name       => 'Unmanaged Device',
    model      => 'Procurve 4200VL',
    deviceType => 'Server'
  }
}

oneview_unmanaged_device{'Unmanaged Device Find':
  ensure  => 'found',
  require => Oneview_unmanaged_device['Unmanaged Device Add'],
  data    =>
  {
    name => 'Unmanaged Device',
  }
}

oneview_unmanaged_device{'Unmanaged Device Find All':
  ensure  => 'found',
  require => Oneview_unmanaged_device['Unmanaged Device Find']
}

oneview_unmanaged_device{'Unmanaged Device Get Environmental Configuration':
  ensure  => 'get_environmental_configuration',
  require => Oneview_unmanaged_device['Unmanaged Device Find All'],
  data    =>
  {
    name => 'Unmanaged Device'
  }
}

oneview_unmanaged_device{'Unmanaged Device Edit':
  ensure  => 'present',
  require => Oneview_unmanaged_device['Unmanaged Device Get Environmental Configuration'],
  data    =>
  {
    name     => 'Unmanaged Device',
    new_name => 'Edited UD'
  }
}

oneview_unmanaged_device{'Unmanaged Device Remove':
  ensure  => 'absent',
  require => Oneview_unmanaged_device['Unmanaged Device Edit'],
  data    =>
  {
    # name       => 'Edited UD',
    model      => 'Procurve 4200VL',
    deviceType => 'Server'
  }
}
