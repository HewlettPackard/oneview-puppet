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

$aliasname = '172.18.13.11'
$remoteip = '172.18.13.11'

# Imports the given Server certificate into the appliance
oneview_server_certificate{'Import Certificates from RemoteIP':
    ensure => 'import',
    data   => {
      remoteIp  => $remoteip,
      aliasName => $aliasname
    }
}

# Retrieves the web server certificate
oneview_server_certificate{'Get Certificates from RemoteIP':
    ensure  => 'get_certificate',
    require => Oneview_server_certificate['Import Certificates from RemoteIP'],
    data    => {
      remoteIp  => $remoteip
    }
}

oneview_server_certificate{'sc1 Retrieve Certificates':
    ensure => 'retrieve',
    data   => {
      aliasName => $aliasname
    }
}

# Replaces the existing certificate with a new  certificate for the alias name provided as part of {aliasName}
oneview_server_certificate{'Update Certificates from RemoteIP':
    ensure => 'create_or_update',
    data   => {
      remoteIp  => $remoteip,
      aliasName => $aliasname
    }
}

# Removes the SSL certificate having alias name specified as part of {aliasName}
oneview_server_certificate{'Removes Certificates from RemoteIP':
    ensure  => 'remove',
    require => Oneview_server_certificate['Update Certificates from RemoteIP'],
    data    => {
      aliasName => $aliasname
    }
}
