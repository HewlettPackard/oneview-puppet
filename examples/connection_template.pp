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

# This resource cannot be created or deleted through 'present' and 'absent'

oneview_connection_template{'Connection Template Found':
  ensure => 'found',
  # data   =>
  # {
  #   name => 'Edited Name'
  # }
}

oneview_connection_template{'Connection Template Default Connection Template':
  ensure => 'get_default_connection_template'
}

oneview_connection_template{'Connection Template Edit':
  ensure => 'present',
  data   =>
  {
    name     => 'My CT',
    new_name => 'Edited CT'
  }
}
