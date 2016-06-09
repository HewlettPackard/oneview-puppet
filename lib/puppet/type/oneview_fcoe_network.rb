Puppet::Type.newtype(:oneview_fcoe_network) do
  desc "Oneview's FCoE network"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

  end


  newparam(:name, :namevar => true) do
    desc "FCoE network name"
  end

  newparam(:data) do
    desc "FCoE network data hash containing all specifications for the
    network"
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, "Inserted value for data is not valid"
      end
    end
  end



end
