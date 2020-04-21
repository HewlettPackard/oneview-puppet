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

  def exists?
    prepare_environment
    empty_data_check([nil, :get_certificate, :retrieve, :remove, :import, :create_or_update])
  end

  def get_certificate
    server_certificate = @resource_type.new(@client)
    server_certificate.data['remoteIp'] = @data.delete('remoteIp')
    server_certificate.get_certificate
  end

  def retrieve
    server_certificate = @resource_type.new(@client)
    server_certificate.data['aliasName'] = @data.delete('aliasName')
    server_certificate.retrieve!
    true
  end

  def import
    server_certificate = @resource_type.new(@client)
    @options = get_certificate
    server_certificate.data['type'] = 'CertificateInfoV2'
    server_certificate.data['certificateDetails'] = []
    server_certificate.data['certificateDetails'][0] = {
      'type' => @options['certificateDetails'][0]['type'],
      'base64Data' => @options['certificateDetails'][0]['base64Data']
    }
    server_certificate.import
  end

  def create_or_update
    server_certificate = @resource_type.new(@client)
    aliasname = @data['aliasName']
    @response = get_certificate
    server_certificate.data['certificateDetails'] = []
    server_certificate.data['certificateDetails'][0] = {
      'type' => @response['certificateDetails'][0]['type'],
      'base64Data' => @response['certificateDetails'][0]['base64Data']
    }
    server_certificate.data['uri'] = '/rest/certificates/servers/' + aliasname
    server_certificate.update
    true
  end

  def remove
    server_certificate = @resource_type.new(@client)
    server_certificate.data['aliasName'] = @data.delete('aliasName')
    server_certificate.remove
  end

  def self.api_version
    600
  end

  def self.resource_name
    'ServerCertificate'
  end
end
