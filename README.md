[![Puppet Forge](https://img.shields.io/puppetforge/v/hewlettpackard/oneview.svg)](https://forge.puppet.com/hewlettpackard/oneview)
[![Build Status](https://travis-ci.org/HewlettPackard/oneview-puppet.svg?branch=master)](https://travis-ci.org/HewlettPackard/oneview-puppet)
[![Coverage Status](https://coveralls.io/repos/github/HewlettPackard/oneview-puppet/badge.svg?branch=master)](https://coveralls.io/github/HewlettPackard/oneview-puppet?branch=master)
[![Inline docs](http://inch-ci.org/github/HewlettPackard/oneview-puppet.svg?branch=master)](http://inch-ci.org/github/HewlettPackard/oneview-puppet)

# Puppet Module for HPE OneView

#### Table of Contents

1. [Overview](#overview)
2. [Module description](#module-description)
3. [Setup](#setup)
    * [Requirements](#requirements)
    * [Beginning with the Puppet Module for HPE OneView](#beginning-with-the-puppet-module-for-hpe-oneview)
4. [Usage](#usage)
    * [OneView Appliance authentication](#oneview-appliance-authentication)
    * [Synergy Image Streamer Authentication](#synergy-image-streamer-authentication)
    * [Types and providers](#types-and-providers)
5. [Reference](#reference)
6. [Contributing and feature requests](#contributing-and-feature-requests)
7. [License](#license)
8. [Version and changes](#version-and-changes)
9. [Authors](#authors)

## Overview

The Puppet Module for HPE OneView provides resource style declaration capabilities to Puppet manifests for managing HPE OneView Appliances.

## Module description

The Puppet Module for HPE OneView allows for management of HPE OneView Appliances through the use of puppet manifests and resource style declarations, which internally make use of the HPE OneView Ruby SDK and HPE OneView API.

It adds several resource types to puppet, and uses ensurable methods such as `present`, `absent` and other custom ensurable methods to manage the appliance to allow the user to easily create, update, query and delete resources.

For more information on the Puppet module for HPE OneView resource types and their specifications, see the [Usage](#usage) and [examples](examples).

## Setup

### Requirements

  - Puppet V4.1 or greater
  - Ruby V2.2.3 or greater
  - [oneview-sdk-ruby](https://github.com/HewlettPackard/oneview-sdk-ruby) V3.1.0 or greater (available as a gem)

### Beginning with the Puppet Module for HPE OneView

To install this module from the Puppet Forge, with enough permissions to install puppet modules, use the command:
```
puppet module install hewlettpackard-oneview
```

Alternatively, you can clone the source code from https://github.com/HewlettPackard/oneview-puppet into your Puppet module path using the following command:
```bash
git clone https://github.com/HewlettPackard/oneview-puppet <your_module_path>/oneview
```

:exclamation: HPE recommends that the cloned directory be named `oneview`. It should also be noted that if the directory name contains any dashes it will not be found by puppet.

## Usage

### OneView Appliance Authentication

The attributes required for authenticating with your HPE OneView Appliance are:

* `ONEVIEW_URL` - The web address for the HPE OneView appliance. For example, https://oneview.example.com
* `ONEVIEW_TOKEN` - Set either this or the ONEVIEW_USER and ONEVIEW_PASSWORD.
* `ONEVIEW_USER` - The HPE OneView appliance username. This defaults to **Administrator**.
* `ONEVIEW_PASSWORD` - The HPE OneView appliance password.
* `ONEVIEW_API_VERSION` - This defaults to the 200 API version (Minimum supported by oneview-sdk-ruby).
* `ONEVIEW_LOG_LEVEL` - The log level of the HPE OneView appliance. This defaults to **info**
* `ONEVIEW_SSL_ENABLED` - HPE recommends setting this value to **true**
* `ONEVIEW_HARDWARE_VARIANT` - Set this to C7000 or Synergy, according to the appliance's enclosure's model. This defaults to **C7000**
:warning: The `Synergy` hardware variant is only available for API version >= 300 (OneView 3.0) :warning:


You can assign attributes for your appliances using three methods:

- Create a json file named `login.json` on your working directory, and enter the authentication information for your appliance. See [login.json](examples/login.json) for an example.

- If you do not want to use the login file on the working directory, any json file containing the authentication information for the appliance can be used by setting the following environment variable:

	* `ONEVIEW_AUTH_FILE` - This environment variable should contain the full path to the json file containing the authentication information.

- Directly declare the authentication attributes mentioned previously as environment variables. The module will automatically use those values.

:exclamation: **NOTE:** All information stored on the login file or json files should be in clear text. To avoid security issues HPE recommends verifying the access permissions for those files.

:lock: Tip: If you have Docker installed you can use the Dockerfile provided to build an image. Example scripts are also provided in the [docker](docker) folder for building and running using environment variables for OneView parameters (and proxies if required).

Once the authentication is prepared and the manifests containing the resources are written, you can use ``` puppet apply <manifest>``` to run your manifests and execute the desired changes to the system.

### Synergy Image Streamer Authentication

The attributes required for authenticating with your HPE Synergy Image Streamer Appliance are:

* `I3S_URL` - The web address for the HPE Image Streamer appliance. For example, https://imagestreamer.example.com
* `I3S_TOKEN` - Session token used for authentication.
* `I3S_API_VERSION` - This defaults to the 300 API version (Minimum supported for Synergy hardware variant).
* `I3S_LOG_LEVEL` - The log level of the HPE ImageStreamer appliance. This defaults to **info**
* `I3S_SSL_ENABLED` - HPE recommends setting this value to **true**


You can assign attributes for your appliances using three methods:

- Create a json file named `login_i3s.json` on your working directory, and enter the authentication information for your appliance. See [login_i3s.json](examples/login_i3s.json) for an example.

- If you do not want to use the login file on the working directory, any json file containing the authentication information for the appliance can be used by setting the following environment variable:

	* `I3S_AUTH_FILE` - This environment variable should contain the full path to the json file containing the authentication information.

- Directly declare the authentication attributes mentioned previously as environment variables. The module will automatically use those values.

:exclamation: **NOTE:** All information stored on the login file or json files should be in clear text. To avoid security issues HPE recommends verifying the access permissions for those files.

### Types and Providers

#### General

Most resources of the Puppet module for HPE OneView accept the following ensurable methods:
* `present` - Creates/adds/updates resources on which those operations are permitted.
* `absent` - Deletes/removes resources.
* `found` - Searches for resources of a specific type on the appliance (with or without specific filters), and prints the information to the standard output.

The majority of the ensurable methods on the resources require a `data` parameter.
Inside `data` a hash should be informed with all the information required for the operation to be performed.

All `get_` ensurable methods send information that is retrieved to the standard output.

To provide easier deployment and management of infrastructure, all resources tags that either contain or require an `Uri` can receive either the "name" or a "name, resource type" combination of parameters instead of the uri as the field value, unless otherwise specified.

For a uri clearly related to a resource, such as in `enclosureUri`, the name can be given instead of the uri, For example:
```ruby
enclosureUri => 'Puppet Example Enclosure'
```
instead of
``` ruby
enclosureUri => '/rest/enclosures/09SGH100X6J1'
```
and in the case of a general tag which does not specify its resource, such as mountUri, a "name, resource type" can be provided, For example:
``` ruby
mountUri => 'Puppet Example Enclosure, enclosure',
```
instead of
``` ruby
mountUri => '/rest/enclosures/09SGH100X6J1',
```

A sample snippet of a manifest:

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

General examples of the usage for each resource and ensurable can be found in the [examples](examples) directory.

For more details for each resource type that the Puppet module for HPE OneView adds and their unique ensurable methods, refer to [Resources](RESOURCES.md).

## Reference

The Puppet Module for HPE OneView uses the HPE OneView-Ruby-SDK to make all API calls and the HPE OneView API to execute all actions.

More information on the OneView-Ruby-SDK can be found on the official git repository:
https://github.com/HewlettPackard/oneview-sdk-ruby

For additional information about the HPE OneView API and about the attributes and options it manages, go to:
http://h17007.www1.hpe.com/docs/enterprise/servers/oneview2.0/cic-api/en/api-docs/current/index.html

## Contributing and feature requests

**Contributing:** You know the drill. Fork it, branch it, change it, commit it, and pull-request it. We are passionate about improving this project, and glad to accept help to make it better.

**NOTE:** We reserve the right to reject changes that we feel do not fit the scope of this project. For feature additions, please open an issue to discuss your ideas before doing the work.

**Feature Requests:** If you have needs not being met by the current implementation, please let us know (via a new issue). This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

## License

This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more information.

## Version and changes

To view history and notes for this version, view the [Changelog](CHANGELOG.md).

## Authors

- Ana Campesan - [@anazard](https://github.com/anazard)
- Chris Hurley - [@chrishpe](https://github.com/chrishpe)
- Felipe Bulsoni - [@fgbulsoni](https://github.com/fgbulsoni)
- Ricardo Piantola - [@piantola](https://github.com/piantola)
