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

# Gets the server profile template by its name, retrieves it and sends back the Object
# Fails if the spt does not exist in the Appliance
def get_spt(message = nil)
  data = data_parse
  Puppet.notice("\n\n#{message}\n") if message
  spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
  raise 'No Server Profile Templates were found in Oneview Appliance.' unless spt.retrieve!
  spt
end
