################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

# NOTE: Firmware options require a Service Pack to already be uploaded into the appliance
# NOTE 2: As with all resources, the found ensurable accepts a data as an optional filter field.

# Variable declaration
$enc_name = '0000A66101'

oneview_enclosure{'Enclosure Create':
    ensure => 'present',
    data   => {
      name              => $enc_name,
      hostname          => '172.18.1.13',
      username          => 'dcs',
      password          => 'dcs',
      #state             => 'Monitored',
      licensingIntent   => 'OneViewNoiLO',
      enclosureGroupUri => ''
      # firmwareBaselineUri => 'Service Pack for ProLiant',
      # updateFirmwareOn => 'EnclosureOnly'
    }
}

oneview_enclosure{'Enclosure Update':
    ensure  => 'present',
    require => Oneview_enclosure['Enclosure Create'],
    data    => {
      name              => $enc_name,
      new_name          => 'Puppet_Test_Enc_Updated',
      enclosureGroupUri => 'EG',
    }
}

oneview_enclosure{'Enclosure Update_2':
    ensure  => 'present',
    require => Oneview_enclosure['Enclosure Create'],
    data    => {
      name              => 'Puppet_Test_Enc_Updated',
      new_name          => $enc_name,
      enclosureGroupUri => 'EG',
    }
}

oneview_enclosure{'Enclosure Found':
    ensure  => 'found',
    require => Oneview_enclosure['Enclosure Update'],
    data    => {
        name            => $enc_name,
#         licensingIntent => 'OneView'
    }
}

oneview_enclosure{'Enclosure configured':
    ensure  => 'set_configuration',
    require => Oneview_enclosure['Enclosure Found'],
    data    => {
        name            => $enc_name,
#        licensingIntent => 'OneView'
    }
}

oneview_enclosure{'Enclosure retrieved environmental configuration':
    ensure  => 'get_environmental_configuration',
    require => Oneview_enclosure['Enclosure configured'],
    data    => {
        name            => $enc_name,
#        licensingIntent => 'OneView'
    }
}

oneview_enclosure{'Enclosure set refresh state':
    ensure  => 'set_refresh_state',
    require => Oneview_enclosure['Enclosure retrieved environmental configuration'],
    data    => {
        name         => $enc_name,
        refreshState => 'RefreshPending',
    }
}

# Bay number is required only while running on C7000
oneview_enclosure{'Create Certificate signing request':
    ensure => 'create_csr',
    data   => {
        uri                => '/rest/enclosures/0000000000A66101',
        type               => 'CertificateDtoV2',
        organization       => 'Acme Corp.',
        organizationalUnit => 'IT',
        locality           => 'Townburgh',
        state              => 'Mississippi',
        country            => 'US',
        email              => 'admin@example.com',
        commonName         => 'fe80::2:0:9:1%eth2',
#        bay_number         => '1'
    }
}

# Bay number is required only while running on C7000
oneview_enclosure{'Get certificate signing request':
    ensure => 'get_csr',
    data   => {
        uri        => '/rest/enclosures/0000000000A66101',
#        bay_number => '1'
    }
}

# Bay number is required only while running on C7000
oneview_enclosure{'Import certificate signing request':
    ensure  => 'import_csr',
    require => Oneview_enclosure['Get certificate signing request'],
    data    => {
        uri        => '/rest/enclosures/0000000000A66101',
#        bay_number => '1'
    }
}

# Leaving this commented since it requires a script to be put inside the enclosure to work
# oneview_enclosure{'Enclosure get script':
#     ensure  => 'get_script',
#     require => Oneview_enclosure['Enclosure set refresh state'],
#     data    => {
#         name              => 'Puppet_Test_Enclosure',
#     }
# }

oneview_enclosure{'Enclosure retrieve utilization':
    ensure  => 'get_utilization',
    require => Oneview_enclosure['Enclosure set refresh state'],
    data    => {
        name                   => $enc_name,
        utilization_parameters => {
          view => 'day'
          },
    }
}

# This example works only for C7000
# oneview_enclosure{'Enclosure Delete':
#     ensure  => 'absent',
#     require => Oneview_enclosure['Enclosure retrieve utilization'],
#     data    => {
#         name => $enc_name,
#     }
# }
