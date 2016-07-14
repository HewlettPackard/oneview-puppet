require File.expand_path(File.join(File.dirname(__FILE__), '../provider', 'login'))

def uri_validation(data)
  client = OneviewSDK::Client.new(login)
  uri_recursive_hash(client, data)
  data
end

def uri_recursive_hash(client, data)
  data.each do |key, value|
    # in case the key is either an array or hash
    hash_array_check(client, data[key])
    # next if -the uri is already declared- or -the parameter name does not require a uri-
    next if value[0..6].include?('/rest/') || !(key.include? 'Uri')
    # looks for the resource
    resource = get_class(key).find_by(client, name: value)
    # fails if resource returns an empty hash (no results)
    raise 'One or more resources have not been found in the Appliance.' if resource.empty?
    # replaces the parameter name by its uri
    data[key] = resource.first.data['uri']
  end
end

# Broken-down blocks

# keeps uri_recursive_hash going in case of String, sends to another method
# in case of arrays or hashes
def hash_array_check(client, data)
  uri_recursive_hash(client, data) if data.is_a?(Hash)
  uri_recursive_array(client, data) if data.is_a?(Array)
end

# turns the array into a hash
def uri_recursive_array(client, data)
  data.each do |item|
    uri_recursive_hash(client, item) if item.is_a?(Hash)
  end
end

def get_class(key)
  # this gets the SDK class based on key.to_s, removing 'Uri' and capitalizing the 1st letter
  Object.const_get("OneviewSDK::#{key.to_s[0].upcase}#{key[1..key.size - 4]}")
end
