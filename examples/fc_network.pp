
oneview_fc_network{'fc1':
    ensure  => 'present',
    data    => {
      name                      =>  'OneViewSDK Test FC Network',
      connectionTemplateUri     => nil,
      autoLoginRedistribution   => true,
      fabricType                => 'FabricAttach',
    }
}

oneview_fc_network{'fc2':
    ensure  => 'present',
    require => Oneview_fc_network['fc1'],
    data    => {
      name                      => 'OneViewSDK Test FC Network',
      new_name                  => 'Updated OneViewSDK Test FC Network',
      connectionTemplateUri     => nil,
      autoLoginRedistribution   => true,
      fabricType                => 'FabricAttach',
    }
}

oneview_fc_network{'fc3':
    ensure  => 'found',
    require => Oneview_fc_network['fc2'],
    data    => {
      name                      => 'Updated OneViewSDK Test FC Network',
      autoLoginRedistribution   => true,
      fabricType                => 'FabricAttach',
    }
}

oneview_fc_network{'fc4':
    ensure  => 'absent',
    require => Oneview_fc_network['fc3'],
    data    => {
      name                      => 'Updated OneViewSDK Test FC Network',
      connectionTemplateUri     => nil,
      autoLoginRedistribution   => true,
      fabricType                => 'FabricAttach',
    }
}

oneview_fc_network{'fc5':
    ensure  => 'found',
    require => Oneview_fc_network['fc4'],
    data    => {
      name                      => 'Updated OneViewSDK Test FC Network',
      autoLoginRedistribution   => true,
      fabricType                => 'FabricAttach',
    }
}
