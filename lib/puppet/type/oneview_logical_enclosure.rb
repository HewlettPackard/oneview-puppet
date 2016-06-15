Puppet::Type.newtype(:oneview_logical_enclosure) do
  desc "Oneview's Logical Enclosure"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_script) do
      provider.get_script
    end

    newvalue(:set_script) do
      provider.set_script
    end

    newvalue(:updated_from_group) do
      provider.updated_from_group
    end

    newvalue(:dumped) do
      provider.dumped
    end

  end

  # Debug warning
  # Puppet.warning("Puppet has passed through the type")

  newparam(:name, :namevar => true) do
    desc "Logical Enclosure name"
  end

  newparam(:data) do
    desc "Logical Enclosure data hash containing all specifications for the
    network"
    validate do |value|
      unless value.class == Hash
        raise(ArgumentError, "Invalid Data Hash")
      end
    end
  end



end
