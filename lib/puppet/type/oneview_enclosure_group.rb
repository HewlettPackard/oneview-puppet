Puppet::Type.newtype(:oneview_enclosure_group) do

  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end
    newvalue(:get_script) do
        provider.get_script
    end
    newvalue(:set_script) do
        provider.set_script
    end
  end

  newparam(:name, :namevar => true) do
    desc "Enclosure Group name"
  end

  newparam(:data) do
    desc "Enclosure Group data hash containing all specifications for the
    resource"
    validate do |value|
      unless value.class == Hash
        raise(ArgumentError, "Invalid Data Hash")
      end
    end
  end

end
