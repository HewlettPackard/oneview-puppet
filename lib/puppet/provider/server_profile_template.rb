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

# This method gets the resource URIs from their names when needed
def spt_parse(data)
  # as the hash cant be edited when its iterating, we modify a clone instead
  data_clone = data.clone
  data.each do |key, value|
    # list of resources that require their uri
    if key['enclosureGroup'] || key['serverHardwareType']
      # deleting the key from the clone hash
      data_clone.delete(key)
      # getting the object from a string
      # capitalizing the first letter + getting the remaining ones as they are
      # '.capitalize' alone will return something like Firstlettercapitalizedonly
      resource = Object.const_get("OneviewSDK::#{key.to_s[0].upcase}#{key[1..key.size]}")
      # assigning a new variable "...Uri" to the hash
      data_clone["#{key}Uri"] = get_uri(value, resource)
    end
  end
  data_clone
end

def get_spt(data)
  spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
  spt.retrieve!
end
