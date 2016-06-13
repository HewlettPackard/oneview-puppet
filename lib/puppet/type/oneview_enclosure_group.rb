Puppet::Type.newtype(:oneview_enclosure_group) do

  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end
  end


  newparam(:data, :namevar => true) do
    desc "Hash containing all the attributes for the new Enclosure Group"
    validate do |value|
      unless value.class == Hash
        raise(ArgumentError, "Invalid Data Hash")
      end
    end
  end

end
