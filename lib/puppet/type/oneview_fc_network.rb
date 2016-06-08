Puppet::Type.newtype(:oneview_fc_network) do
  desc "Oneview's FC network"

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
    desc "FC network name"
  end

  newparam(:data) do
    desc "FC network data hash containing all specifications for the
    network"
    validate do |value|
      unless value.class == Hash
        raise(ArgumentError, "Invalid Data Hash")
      end
    end
  end



end
