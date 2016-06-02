Puppet::Type.newtype(:oneview_ethernet_network) do
  desc "Oneview's ethernet network"

  ensurable

  # Debug warning
  # Puppet.warning("Puppet has passed through the type")

  newparam(:name, :namevar => true) do
    desc "Ethernet network name"
  end

  newparam(:data) do
    desc "Ethernet network name"
  end

end
