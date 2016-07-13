require File.expand_path(File.join(File.dirname(__FILE__), '../provider', 'login'))

def uri_validation(data)
  client = OneviewSDK::Client.new(login)
  uri_recursive(client, data)
  data
end

def uri_recursive(client, data)
  data.each do |key, value|
    # in case the key is either an array or hash
    uri_recursive(client, data[key]) if data[key].class == Array || data[key].class == Hash
    # next if -the uri is already declared- or -the parameter name does not require a uri-
    next if value[0..6] == '/rest/' || !(key.include? 'Uri')
    # looks for the resource
    resource = get_class(key).find_by(client, name: value)
    # fails if resource returns an empty hash (no results)
    raise 'One of the resources has not been found in the Appliance.' if resource.empty?
    # replaces the parameter name by its uri
    data[key] = resource.first.data['uri']
  end
end

def get_class(key)
  # this gets the SDK class based on key.to_s, removing 'Uri' and capitalizing the 1st letter
  Object.const_get("OneviewSDK::#{key.to_s[0].upcase}#{key[1..key.size - 4]}")
end
