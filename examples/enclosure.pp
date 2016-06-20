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

# oneview_enclosure{'Enclosure Create':
#     ensure => 'present',
#     data   => {
#       name              => 'Puppet-Test-Enclosure',
#       hostname          => '172.18.1.13',
#       username          => 'dcs',
#       password          => 'dcs',
#       enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#       licensingIntent   => 'OneView'
#     }
# }
#
# oneview_enclosure{'Enclosure Update':
#     ensure  => 'present',
#     require => Oneview_enclosure['Enclosure Create'],
#     data    => {
#       name                  => 'Enclosure',
#       new_name              => 'New Enclosure Name',
#       vlanId                => '100',
#       connectionTemplateUri => 'nil',
#       type                  => 'enclosure'
#     }
# }
#
# oneview_enclosure{'Enclosure Found':
#     ensure  => 'found',
#     # require => Oneview_enclosure['Enclosure Update'],
#     data    => {
#         name              => 'OneViewSDK_Test_Enclosure',
#         enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#         licensingIntent   => 'OneView'
#     }
# }

# oneview_enclosure{'Enclosure configured':
#     ensure  => 'configured',
#     # require => Oneview_enclosure['Enclosure Update'],
#     data    => {
#         name              => 'OneViewSDK_Test_Enclosure',
#         enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#         licensingIntent   => 'OneView'
#     }
# }

# oneview_enclosure{'Enclosure retrieved environmental configuration':
#     ensure  => 'retrieved_environmental_configuration',
#     # require => Oneview_enclosure['Enclosure Update'],
#     data    => {
#         name              => 'OneViewSDK_Test_Enclosure',
#         enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#         licensingIntent   => 'OneView'
#     }
# }
#
# oneview_enclosure{'Enclosure set refresh state':
#     ensure  => 'set_refresh_state',
#     # require => Oneview_enclosure['Enclosure Update'],
#     data    => {
#         name              => 'OneViewSDK_Test_Enclosure',
#         enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#         licensingIntent   => 'OneView',
#         refreshState      => 'RefreshPending',
#     }
# }

# oneview_enclosure{'Enclosure retrieve script':
#     ensure  => 'script_retrieved',
#     # require => Oneview_enclosure['Enclosure Update'],
#     data    => {
#         name              => 'OneViewSDK_Test_Enclosure',
#         enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#         licensingIntent   => 'OneView',
#         refreshState      => 'RefreshPending',
#     }
# }

# oneview_enclosure{'Enclosure retrieve utilization':
#     ensure  => 'retrieved_utilization',
#     # require => Oneview_enclosure['Enclosure Update'],
#     data    => {
#         name                   => 'OneViewSDK_Test_Enclosure',
#         enclosureGroupUri      => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
#         licensingIntent        => 'OneView',
#         utilization_parameters => {
#           view => 'day'
#           },
#     }
# }

#
# oneview_enclosure{'Enclosure Delete':
#     ensure  => 'absent',
#     # require => Oneview_enclosure['Enclosure Found'],
#     data    => {
#       name                  => 'Puppet-Test-Enclosure',
#     }
# }
