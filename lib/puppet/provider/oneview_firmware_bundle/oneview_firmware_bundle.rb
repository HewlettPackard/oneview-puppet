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

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_firmware_bundle).provide(:oneview_firmware_bundle) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::FirmwareBundle
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  # Provider methods
  def exists?
    @data = data_parse
    raise 'A "firmware_bundle_path" is required for this operation' unless @data['firmware_bundle_path']
  end

  def create
    @resourcetype.add(@client, @data['firmware_bundle_path'])
  end

  def destroy
    raise '"Absent" is not a valid ensurable for firmware bundle.'
  end

  def found
    raise '"Found" is not a valid ensurable for firmware bundle.'
  end
end
