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

# NOTE: Firmware options require a Service Pack to already be uploaded into the appliance
# NOTE 2: As with all resources, the found ensurable accepts a data as an optional filter field.

oneview_enclosure{'Enclosure Create':
    ensure => 'present',
    data   => {
      name              => 'Puppet_Test_Enclosure',
      hostname          => '172.18.1.13',
      username          => 'dcs',
      password          => 'dcs',
      #state             => 'Monitored',
      licensingIntent   => 'OneViewNoiLO',
      enclosureGroupUri => '/rest/enclosure-groups/8cc4aad0-5dac-47e5-871d-050289855567'
      # firmwareBaselineUri => 'Service Pack for ProLiant',
      # updateFirmwareOn => 'EnclosureOnly'
    }
}

oneview_enclosure{'Enclosure Update':
    ensure  => 'present',
    require => Oneview_enclosure['Enclosure Create'],
    data    => {
      name              => 'Puppet_Test_Enclosure',
      rackName          => 'Puppet_Test_Rack1',
      enclosureGroupUri => 'Puppet Enc Group Test',
      # enclosureGroupUri => '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
    }
}

oneview_enclosure{'Enclosure Found':
    ensure => 'found',
    # require => Oneview_enclosure['Enclosure Update'],
    data   => {
        name            => 'Puppet_Test_Enclosure',
        licensingIntent => 'OneView'
    }
}

oneview_enclosure{'Enclosure configured':
    ensure  => 'set_configuration',
    require => Oneview_enclosure['Enclosure Found'],
    data    => {
        name            => 'Puppet_Test_Enclosure',
        licensingIntent => 'OneView'
    }
}

oneview_enclosure{'Enclosure retrieved environmental configuration':
    ensure  => 'get_environmental_configuration',
    require => Oneview_enclosure['Enclosure configured'],
    data    => {
        name            => 'Puppet_Test_Enclosure',
        licensingIntent => 'OneView'
    }
}

oneview_enclosure{'Enclosure set refresh state':
    ensure  => 'set_refresh_state',
    require => Oneview_enclosure['Enclosure retrieved environmental configuration'],
    data    => {
        name         => 'Puppet_Test_Enclosure',
        refreshState => 'RefreshPending',
    }
}

oneview_enclosure{'Create Certificate signing request':
    ensure => 'create_csr',
    data   => {
        uri                => '/rest/enclosures/09SGH104X6J1',
        type               => 'CertificateDtoV2',
        organization       => 'Acme Corp.',
        organizationalUnit => 'IT',
        locality           => 'Townburgh',
        state              => 'Mississippi',
        country            => 'US',
        email              => 'admin@example.com',
        commonName         => 'fe80::2:0:9:1%eth2',
        bay_number         => '1'
    }
}

oneview_enclosure{'Get certificate signing request':
    ensure => 'get_csr',
    data   => {
        uri        => '/rest/enclosures/09SGH104X6J1',
        bay_number => '1'
    }
}

oneview_enclosure{'Import certificate signing request':
    ensure  => 'import_csr',
    require => Oneview_enclosure['Get certificate signing request'],
    data    => {
        uri        => '/rest/enclosures/09SGH104X6J1',
        bay_number => '1'
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
        name                   => 'Puppet_Test_Enclosure',
        utilization_parameters => {
          view => 'day'
          },
    }
}


oneview_enclosure{'Enclosure Delete':
    ensure  => 'absent',
    require => Oneview_enclosure['Enclosure retrieve utilization'],
    data    => {
        name => 'Puppet_Test_Enclosure',
    }
}
