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

Puppet::Type.type(:oneview_volume_template).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::VolumeTemplate.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data
         )
    end
  end

  # TODO: eventually implement this prefetch method as it seems useful but requires an investigation into it
  # def self.prefetch(resources)
  #   packages = instances
  #   resources.keys.each do |name|
  #     if provider = packages.find { |pkg| pkg.name == name }
  #       resources[name].provider = provider
  #     end
  #   end
  # end

  def pretty(arg)
    return puts arg if arg.instance_of?(String)
    puts JSON.pretty_generate(arg)
  end

  # Provider methods

  def exists?
    state = resource['ensure'].to_s
    resourcetype = OneviewSDK::VolumeTemplate
    # # TODO: This validation should be run on the "type" itself
    # # In case it is not, this part of the code should be enabled
    # # Verify if data is set for resources that need it, else fail
    # unless resource['data'] || (state == 'found')
    #   fail("A 'data' Hash is required for the present operation")
    # end
    data = data_parse
    volume_template = if state == 'present'
                        resource_update(data, resourcetype)
                        OneviewSDK::VolumeTemplate.find_by(@client, name: data['name'])
                      else
                        OneviewSDK::VolumeTemplate.find_by(@client, data)
                      end
    # Puppet.notice("#{resource} '#{data['name']}' located in Oneview Appliance") unless volume_template.empty? || !data['name']
    !volume_template.empty?
  end

  def create
    data = data_parse
    # Creates the volume template
    volume_template = OneviewSDK::VolumeTemplate.new(@client, data)
    volume_template.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    data = data_parse
    volume_template = OneviewSDK::VolumeTemplate.find_by(@client, name: data['name']).first
    if volume_template
      volume_template.delete
    else
      Puppet.notice("#{resource} '#{data['name']}' not located in Oneview Appliance")
    end
    @property_hash.clear
  end

  def found
    # Searches VolumeTemplates with data matching the manifest data
    data = data_parse
    retrieved_volume_template = OneviewSDK::VolumeTemplate.find_by(@client, data)
    # If volume_template are found, iterate through them and notify. Else just notify.
    if !retrieved_volume_template.empty?
      retrieved_volume_template.each do |volume_template|
        Puppet.notice "\n\n Found matching volume template #{volume_template['name']} "\
        "(URI: #{volume_template['uri']}) on Oneview Appliance\n"
      end
      true
    else
      Puppet.notice("\n\n No volume templates with the specified data were found on "\
      "the Oneview Appliance\n")
      false
    end
  end

  def get_connectable_volume_templates
    data = data_parse
    if data['attributes']
      attributes = data['attributes']
      data.delete('attributes')
    end
    volume_template = OneviewSDK::VolumeTemplate.find_by(@client, data).first
    if volume_template
      Puppet.notice("\n\n Getting connectable volume templates now, starting to list: \n")
      pretty volume_template.get_connectable_volume_templates(attributes)
      Puppet.notice("\n End of list \n")
      true
    else
      false
    end
  end
end
