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

oneview_connection_template{'Connection Template Found':
  ensure => 'found',
  data   =>
  {
    name => 'CT'
  }
}

oneview_connection_template{'Connection Template Get Schema':
  ensure => 'get_schema',
  data   =>
  {
    name => 'CT'
  }
}

oneview_connection_template{'Connection Template Get All':
  ensure => 'get_connection_templates'
}

oneview_connection_template{'Connection Template Default Connection Template':
  ensure => 'get_default_connection_template'
}

oneview_connection_template{'Connection Template Edit':
  ensure => 'present',
  data   =>
  {
    name     => 'CT'
    new_name => 'Edited Name',
  }
}

# The following operations should display an error, as this resource can neither be created nor destroyed

oneview_connection_template{'Connection Template Create':
  ensure => 'present',
  data   =>
  {
    name     => 'Random Template'
  }
}

oneview_connection_template{'Connection Template Destroy':
  ensure  => 'absent',
  require => Oneview_connection_template['Connection Template Edit'],
  data    =>
  {
    name     => 'Edited Name'
  }
}
