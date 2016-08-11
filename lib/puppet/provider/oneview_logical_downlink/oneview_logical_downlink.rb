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

Puppet::Type.type(:oneview_logical_downlink).provide(:oneview_logical_downlink) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalDownlink
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check([:found, :get_without_ethernet])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def found
    find_resources
  end

  def get_without_ethernet
    Puppet.notice("\nLogical Downlinks\n")
    ld = @resourcetype.find_by(@client, @data)
    if ld.empty?
      Puppet.warning('There are no logical downlinks without ethernet in the Oneview appliance.')
    else
      ld.each { |item| pretty item.get_without_ethernet.data }
    end
    true
  end
end
