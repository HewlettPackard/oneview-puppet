# Puppet Module for HPE OneView

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Requirements](#requirements)
    * [Beginning with the Puppet Module for HPE OneView](#beginning-with-the-puppet-module-for-hpe-oneview)
4. [Usage](#usage)
    * [Appliance Authentication](#appliance-authentication)
    * [Types and Providers](#types-and-providers)
5. [Reference](#reference)
6. [Contributing and feature requests](#contributing-and-feature-requests)
7. [License](#license)
8. [Version and changes](#version-and-changes)
9. [Authors](#authors)

## Overview

Puppet module which provides resource style declaration capabilities to Puppet manifests for managing HPE Oneview Appliances.

## Module Description

The Puppet Module for HPE OneView allows for management of HPE Oneview Appliances through the use of puppet manifests and resource style declarations, which internally make use of the HPE Oneview Ruby SDK and HPE Oneview API.

It adds several resource types to puppet, and uses ensurables such as 'present', 'absent' and other custom ensurables to manage the appliance and allow the user to easily create, update, query and destroy resources.

For more information on the resource types this module adds to Puppet, and each type specifics, refer to the 'usage' section and examples within this module.

## Setup

### Requirements

  - Ruby >= 2.2.3
  - [oneview-sdk-ruby](https://github.com/HewlettPackard/oneview-sdk-ruby) >= 2.0.0

### Beginning with the Puppet Module for HPE OneView

To install this module from the Puppet Forge, with enough permissions, use the command:
```
puppet module install hpe-oneview
```

Alternatively, you can clone the source code from https://github.com/HewlettPackard/oneview-puppet into your Puppet module path using the following command:
```bash
git clone https://github.com/HewlettPackard/oneview-puppet <your_module_path>/oneview
```

:exclamation: It's recommended that the cloned directory be named `oneview`. It should also be noted that if the directory name contains any dashes it will not be found by puppet.

## Usage

### Appliance Authentication

The attributes required for authenticating with your HPE Oneview Appliance are:

* `ONEVIEW_URL` - The URL to the HPE Oneview appliance. i.e.'https://oneview.example.com'
* `ONEVIEW_TOKEN` - Set EITHER this or the ONEVIEW_USER & ONEVIEW_PASSWORD
* `ONEVIEW_USER` - The HPE Oneview appliance username. This defaults to Administrator
* `ONEVIEW_PASSWORD` - The HPE Oneview appliance password.
* `ONEVIEW_API_VERSION` - This defaults to the 200 API version (Minimum supported by oneview-sdk-ruby)
* `ONEVIEW_LOG_LEVEL` - The log level of the Oneview HPE appliance. This defaults to 'info'
* `ONEVIEW_SSL_ENABLED` - This is strongly encouraged to be set to 'true'


There are three ways to pass in those attributes for the appliance using this module:

- Create a json file named `login.json` on your working directory, and fill it with the authentication information of your appliance

- If it is not desired to use the login file on the working directory, any json file containing the authentication information for the appliance can be used by setting the following environment variable:

	* `ONEVIEW_AUTH_FILE` - This environment variable should contain the full path to the json file containing the authentication information.

- Directly declare the authentication attributes mentioned above as environment variables. The module will automatically use those values.

:exclamation: **NOTE:** It should be noted that all information stored on the login file or json files should be in clear text, so to avoid security issues we strongly recommend verifying the access permissions for those files.

:lock: Tip: If you have Docker installed you can use the Dockerfile provided to build an image. Example scripts are also provided in the [docker](docker) folder for building and running using environment variables for OneView parameters (and proxies if required).

Once the authentication is prepared and the manifests containing the resources are written, you can use ``` puppet apply <manifest>``` to run your manifests and execute the desired changes to the system.

### Types and Providers

#### General -- Most resources of this module accept the following ensurables:

* `present` - Creates/adds/updates resources on which those operations are permitted.
* `absent` - Deletes/removes resources
* `found` - Searches for resources of a specific type on the appliance (with or without specific filters) and prints the information to the standard output.

The majority of the ensurables on the resources require a `data` parameter to be informed, containing a hash written in Puppet DSL with all the information required for the operation to be performed.

All `get_` ensurables output the information retrieved to the standard output.

As a way to provide easier deployment and management of infrastructure, all resources tags that either have or require an `Uri` can receive either the 'name' or a 'name, resource type' combination of parameters instead of the uri as the value to the field, unless otherwise specified.

For a uri clearly related to a resource, as in `enclosureUri`, the name can be given instead of the uri, i.e.:
```ruby
enclosureUri => 'Puppet Example Enclosure'
```
instead of
``` ruby
enclosureUri => '/rest/enclosures/09SGH100X6J1'
```
and in the case of a general tag which does not specify its resource, such as mountUri, a 'name, resource type ' can be provided, i.e.:
``` ruby
mountUri => 'Puppet Example Enclosure, enclosure',
```
instead of
``` ruby
mountUri => '/rest/enclosures/09SGH100X6J1',
```

A sample snippet of what a manifest might look like:

```puppet
oneview_ethernet_network{'Ethernet Network Create':
  ensure => 'present',
  data   => {
    name                  => 'Puppet network',
    vlanId                => '1045',
    purpose               => 'General',
    smartLink             => true,
    privateNetwork        => false,
    connectionTemplateUri => nil,
    type                  => 'ethernet-networkV3'
  }
}

oneview_fc_network{'fc1':
    ensure => 'present',
    data   => {
      name                    => 'OneViewSDK Test FC Network',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

oneview_volume{'volume_1':
    ensure => 'present',
    data   => {
      name                   => 'Oneview_Puppet_TEST_VOLUME_1',
      description            => 'Test volume with common creation: Storage System + Storage Pool',
      provisioningParameters => {
            provisionType     => 'Full',
            shareable         => true,
            requestedCapacity => 1024 * 1024 * 1024,
            storagePoolUri    => 'FST_CPG1',
      },
      snapshotPoolUri        => 'FST_CPG1'
    }
}
```

General examples of the usage for each resource and ensurable can be found inside the [examples](examples) directory.

A more detailed explanation on each resource type added by this module, and their unique ensurables can be found on [Resources](RESOURCES.md).

## Reference

This module uses the HPE oneview-ruby-sdk to make all API calls and the HPE Oneview API to execute all actions.

More information on the oneview-ruby-sdk can be found on the official git repository:
https://github.com/HewlettPackard/oneview-sdk-ruby

More information on the HPE Oneview API, and information on attributes and options for the resources managed by it (which are managed by this module through it) can be found on the following link:
http://h17007.www1.hpe.com/docs/enterprise/servers/oneview2.0/cic-api/en/api-docs/current/index.html

## Contributing and feature requests

**Contributing:** You know the drill. Fork it, branch it, change it, commit it, and pull-request it. We are passionate about improving this project, and glad to accept help to make it better.

NOTE: We reserve the right to reject changes that we feel do not fit the scope of this project, so for feature additions, please open an issue to discuss your ideas before doing the work.

**Feature Requests:** If you have a need that is not met by the current implementation, please let us know (via a new issue). This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

## License

This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more info.

## Version and changes

Verify the [Changelog](CHANGELOG.md) for the history or notes for this version.

## Authors

- Ana Campesan - [@anazard](https://github.com/anazard)
- Chris Hurley - [@chrishpe](https://github.com/chrishpe)
- Felipe Bulsoni - [@fgbulsoni](https://github.com/fgbulsoni)
- Ricardo Piantola - [@piantola](https://github.com/piantola)
