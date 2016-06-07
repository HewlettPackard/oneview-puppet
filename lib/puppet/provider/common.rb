# ============== Common methods ==============

# Removes quotes from nil and false values
def data_parse(resource_data)
  data = resource['data']
  data.each do |key,value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
    data[key] = data[key].to_i if key == 'vlanId'
  end
  return data
end
