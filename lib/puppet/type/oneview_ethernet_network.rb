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
    desc "Ethernet network name"
  end



end
