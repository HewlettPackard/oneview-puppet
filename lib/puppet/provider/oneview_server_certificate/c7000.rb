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

require_relative '../oneview_resource'
require 'oneview-sdk'

Puppet::Type.type(:oneview_server_certificate).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for Server Certificate using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def get_certificate
    server_certificate = OneviewSDK.resource_named('ServerCertificate', api_version)
    server_certificate.get_certificate
  end

  def import
    storage_system_ip = @data.delete('storage_system_ip')
    server_certificate = OneviewSDK.resource_named('ServerCertificate', storage_system_ip)
    @options = server_certificate.get_certificate
    @data[:type] = @options.delete('type')
    @data[:base64Data] = @options.delete('base64Data')
    @data[:certificateDetails] = [
      'type' => @options['certificateDetails'][0]['type'],
      'base64Data' => @options['certificateDetails'][0]['base64Data']
    ]
    server_certificate.import
  end

  def update
    server_certificate = OneviewSDK.resource_named('ServerCertificate', api_version)
    @options = server_certificate.get_certificate
    @data[:type] = @options.delete('type')
    @data[:base64Data] = @options.delete('base64Data')
    @data[:certificateDetails] = [
      'type' => @options['certificateDetails'][0]['type'],
      'base64Data' => @options['certificateDetails'][0]['base64Data']
    ]
    server_certificate.update
  end

  def remove
    storage_system_ip = @data.delete('alias')
    server_certificate = OneviewSDK.resource_named('ServerCertificate', storage_system_ip)
    server_certificate.remove
  end

  def self.api_version
    600
  end

  def self.resource_name
    'ServerCertificate'
  end
end
