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

Puppet::Type.type(:oneview_server_profile).provide :synergy, parent: :c7000 do
  desc 'Provider for OneView Server Profiles using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  # Retrieves all SAS Logical JBOD OR Retrieves a SAS Logical JBOD by name
  def get_sas_logical_jbods
    Puppet.notice("\n\nLogical JBOD Attachments\n")
    if @data['name']
      pretty @resourcetype.get_sas_logical_jbod(@client, @data['name'])
    else
      pretty @resourcetype.get_sas_logical_jbods(@client)
    end
    true
  end

  # Retrieves drives by SAS Logical JBOD name
  def get_sas_logical_jbod_drives
    Puppet.notice("\n\nLogical JBOD Drives\n")
    pretty @resourcetype.get_sas_logical_jbod_drives(@client, @data['name'])
    true
  end

  # Retrieves all SAS Logical JBOD Attachments OR a SAS Logical JBOD Attachment specified in data['name']
  def get_sas_logical_jbod_attachments
    Puppet.notice("\n\nLogical JBOD Attachments\n")
    if @data['name']
      pretty @resourcetype.get_sas_logical_jbod_attachment(@client, @data['name'])
    else
      pretty @resourcetype.get_sas_logical_jbod_attachments(@client)
    end
    true
  end
end
