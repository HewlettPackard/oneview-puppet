Puppet::Type.newtype(:oneview_ethernet_network) do
  desc "Oneview's ethernet network"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

  end

  # Debug warning
  # Puppet.warning("Puppet has passed through the type")

  newparam(:name, :namevar => true) do
    desc "Ethernet network name"
  end

  newparam(:data) do
    desc "Ethernet network data hash containing all specifications for the
    network"
    validate do |value|
      unless value.class == Hash
        raise(ArgumentError, "Invalid Data Hash")
      end
    end
  end



end
