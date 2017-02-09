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

# NOTE: As with all resources, the found ensurable accepts a data as an optional filter field.

image_streamer_plan_script{'plan_script_1':
    ensure => 'present',
    data   => {
      name        => 'Plan Script Puppet',
      description => 'Description of this plan script',
      hpProvided  => false,
      planType    => 'deploy',
      content     => 'echo "test script"',
    }
}

image_streamer_plan_script{'plan_script_2':
    ensure  => 'found',
    require => Image_streamer_plan_script['plan_script_1'],
    data    => {
      planType    => 'deploy'
    }
}

image_streamer_plan_script{'plan_script_3':
    ensure  => 'present',
    require => Image_streamer_plan_script['plan_script_2'],
    data    => {
      name     => 'Plan Script Puppet',
      new_name => 'Plan Script Puppet Renamed'
    }
}

image_streamer_plan_script{'plan_script_4':
    ensure  => 'retrieve_differences',
    require => Image_streamer_plan_script['plan_script_3'],
    data    => {
      name     => 'Plan Script Puppet Renamed'
    }
}

image_streamer_plan_script{'plan_script_5':
    ensure  => 'absent',
    require => Image_streamer_plan_script['plan_script_4'],
    data    => {
      name => 'Plan Script Puppet Renamed'
    }
}
