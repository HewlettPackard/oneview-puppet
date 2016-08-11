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

# This example requires:
# At least 1 logical downlink
# 'LDc3330ee6-8b74-4eaf-9e5d-b14eeb5340b4 (HP VC FlexFabric-20/40 F8 Module)'

# If you need to filter your results by networkUris, declare the network name and its type
oneview_logical_downlink{'Logical Downlink Found':
    ensure => 'found',
    data   =>
    {
      name => 'LDc3330ee6-8b74-4eaf-9e5d-b14eeb5340b4 (HP VC FlexFabric-20/40 F8 Module)',
      # networkUris =>
      # [
      #   {
      #     name => 'Ethernet 1',
      #     type => 'EthernetNetwork'
      #   },
      # ]
    }
}

oneview_logical_downlink{'Logical Downlink Get All (without ethernet)':
    ensure => 'get_without_ethernet'
}

oneview_logical_downlink{'Logical Downlink (without ethernet)':
    ensure => 'get_without_ethernet',
    data   =>
    {
      name => 'LDc3330ee6-8b74-4eaf-9e5d-b14eeb5340b4 (HP VC FlexFabric-20/40 F8 Module)'
    }
}
