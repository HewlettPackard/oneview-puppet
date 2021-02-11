# HPE OneView SDK for Puppet  

## Build Status 
OV Version | 5.60 | 5.50 | 5.40 | 5.30 |
| ------------- |:-------------:| -------------:| -------------:| -------------:|
SDK Version/Tag | [Master](https://github.com/HewlettPackard/oneview-puppet/tree/master) | [v2.9.0](https://github.com/HewlettPackard/oneview-puppet/releases/tag/v2.9.0) | [v2.8.0](https://github.com/HewlettPackard/oneview-puppet/releases/tag/v2.8.0) | [v2.7.0](https://github.com/HewlettPackard/oneview-puppet/releases/tag/v2.7.0) |
Build Status | ![Build status](https://ci.appveyor.com/api/projects/status/u84505l6syp70013?svg=true)| ![Build status](https://ci.appveyor.com/api/projects/status/u84505l6syp70013?svg=true)| ![Build status](https://ci.appveyor.com/api/projects/status/u84505l6syp70013?svg=true)| ![Build status](https://ci.appveyor.com/api/projects/status/u84505l6syp70013?svg=true)|


## Introduction

HPE OneView makes it simple to deploy and manage today’s complex hybrid cloud infrastructure. HPE OneView can help you transform your data center to software-defined, and it supports HPE’s broad portfolio of servers, storage, and networking solutions, ensuring the simple and automated management of your hybrid infrastructure. Software-defined intelligence enables a template-driven approach for deploying, provisioning, updating, and integrating compute, storage, and networking infrastructure.

The Puppet Module for HPE OneView provides resource style declaration capabilities to Puppet manifests for managing HPE OneView Appliances.

The Puppet Module for HPE OneView allows for management of HPE OneView Appliances through the use of puppet manifests and resource style declarations, which makes internal use of the HPE OneView Ruby SDK and HPE OneView API.

It adds several resource types to puppet, and uses ensurable methods such as `present`, `absent` and other custom ensurable methods to manage the appliance to allow users to easily create, update, query and delete resources.

For more information on the Puppet Module for HPE OneView resource types and their specifications, see the [Usage](#usage) and [examples](examples).

## What's New

HPE OneView Puppet library extends support of the SDK to OneView REST API version 2200 (OneView v5.50)

Please refer to [notes](https://github.com/HewlettPackard/oneview-puppet/blob/master/CHANGELOG.md) for more information on the changes , features supported and issues fixed in this version

## Getting Started 

### Requirements

  - Puppet V4.1 or greater
  - Ruby V2.3.1 or greater
  - [oneview-sdk-ruby](https://github.com/HewlettPackard/oneview-sdk-ruby) V5.11.0 or greater (available as a gem)

### Beginning with the Puppet Module for HPE OneView

To install this module from the Puppet Forge, with enough permissions to install puppet modules, use the command:
```
puppet module install hewlettpackard-oneview
```

Alternatively, you can clone the source code from https://github.com/HewlettPackard/oneview-puppet into your Puppet module path using the following command:
```bash
git clone https://github.com/HewlettPackard/oneview-puppet <your_module_path>/oneview
```

:exclamation: **NOTE:** HPE recommends that the cloned directory be named `oneview`. It should also be noted that if the directory name contains any dashes it will not be found by puppet.

## Usage

### OneView appliance authentication

The attributes required for authenticating with your HPE OneView Appliance are:

* `ONEVIEW_URL` - The web address for the HPE OneView appliance. For example, https://oneview.example.com
* `ONEVIEW_TOKEN` - Set either this or the ONEVIEW_USER and ONEVIEW_PASSWORD.
* `ONEVIEW_USER` - The HPE OneView appliance username.
* `ONEVIEW_PASSWORD` - The HPE OneView appliance password.
* `ONEVIEW_API_VERSION` - This defaults to the appliance's max API version if the API version not mentioned in config.
* `ONEVIEW_LOG_LEVEL` - The log level of the HPE OneView appliance. This defaults to **info**
* `ONEVIEW_SSL_ENABLED` - HPE recommends setting this value to **true**
* `ONEVIEW_HARDWARE_VARIANT` - Set this to C7000 or Synergy, according to the appliance's enclosure's model. This defaults to **C7000**
:warning: The `Synergy` hardware variant is only available for API version >= 300 (OneView 3.0) :warning:


You can assign attributes for your appliances using three methods:

1. Create a json file named `login.json` on your working directory, and enter the authentication information for your appliance. See [login_rename.json](examples/login_rename.json) for an example.

2. If you do not want to use the login file on the working directory, any json file containing the authentication information for the appliance can be used by setting the following environment variable:

	* `ONEVIEW_AUTH_FILE` - This environment variable should contain the full path to the json file containing the authentication information.

3. Directly declare the authentication attributes mentioned previously as environment variables. The module will automatically use those values.

:exclamation: **NOTE:** All information stored on the login file or json files should be in clear text. To avoid security issues HPE recommends verifying the access permissions for those files.

### Synergy Image Streamer authentication

The attributes required for authenticating with your HPE Synergy Image Streamer appliance are:

* `IMAGE_STREAMER_URL` - The web address for the HPE Image Streamer appliance. For example, https://imagestreamer.example.com
* `IMAGE_STREAMER_API_VERSION` - The API version for the HPE Image Streamer. This defaults to **300**
* `IMAGE_STREAMER_LOG_LEVEL` - The log level of the HPE Image Streamer appliance. This defaults to **info**
* `IMAGE_STREAMER_SSL_ENABLED` - HPE recommends setting this value to **true**

The following attribute must be set only if you haven't configured the credentials to authenticate with your HPE OneView Appliance:

* `IMAGE_STREAMER_TOKEN` - The authentication token for the HPE Image Streamer. This is the same token used to access the HPE OneView REST API.

:exclamation: **NOTE:** All information stored on the login file or json files should be in clear text. To avoid security issues HPE recommends verifying the access permissions for those files.


You can assign attributes for your appliances using three methods:

1. Create a json file named `login_image_streamer.json` on your working directory, and enter the authentication information for your appliance. See [login_image_streamer.json](examples/login_image_streamer.json) for an example. :exclamation: **NOTE:** You must provide a token only if you haven't configured the credentials to authenticate with your HPE OneView Appliance.

2. If you do not want to use the login file on the working directory, any json file containing the authentication information for the appliance can be used by setting the following environment variable:

	* `IMAGE_STREAMER_AUTH_FILE` - This environment variable should contain the full path to the json file containing the authentication information.

3. Directly declare the authentication attributes mentioned previously as environment variables. The module will automatically use those values.

:exclamation: **NOTE:** All information stored on the login file or json files should be in clear text. To avoid security issues HPE recommends verifying the access permissions for those files.

### Running Examples with Docker
If you'd rather run the examples in a Docker container, you can use the Dockerfile at the top level of this repo.
All you need is Docker and git (optional).

1. Clone this repo and cd into it:
   ```bash
   $ git clone https://github.com/HewlettPackard/oneview-puppet.git
   $ cd oneview-puppet
   ```

   Note: You can navigate to the repo url and download the repo as a zip file if you don't want to use git

2. You can build docker image locally or pull the docker image from Docker Hub.
   #### Build docker image locally
   * Build the docker image locally: `$ docker build -t puppet-oneview .`
   #### Using Docker Hub Image
   * Pull docker image from Docker Hub:
   
   The `hewlettpackardenterprise/hpe-oneview-sdk-for-puppet:<tag>`  docker image contains an installation of oneview-puppet installation you can use by just pulling down the Docker Image:

   The Docker Store image tag consist of two sections: <sdk_version-OV_version>

   ```bash
   # Download and store a local copy of hpe-oneview-sdk-for-puppet and
   # use it as a Docker image.
   $ docker pull hewlettpackardenterprise/hpe-oneview-sdk-for-puppet:v2.9.0-OV5.5
   # Run docker container with below commands.
   $docker run -it --rm \
     -v $(pwd)/:/puppet
     -e ONEVIEW_URL='https://ov.example.com' \
     -e ONEVIEW_USER='Administrator' \
     -e ONEVIEW_PASSWORD='secret123' \
     -e ONEVIEW_SSL_ENABLED=true, \
     -e ONEVIEW_LOG_LEVEL='info' \
     -e ONEVIEW_API_VERSION=800 \
     hewlettpackardenterprise/hpe-oneview-sdk-for-puppet:v2.9.0-OV5.5 puppet apply fc_network.pp --debug --trace
   ```
    Now you can run any of the example manifests in this directory:
```bash
   # Run the container, passing in your credentials to OneView and specifying which example to run.
   # Replace "pwd" with the path of the manifest you'd like to run
   # Replace "fc_network" with the name of the manifest you'd like to run
   
   $ docker run -it --rm \
     -v $(pwd)/:/puppet
     -e ONEVIEW_URL='https://ov.example.com' \
     -e ONEVIEW_USER='Administrator' \
     -e ONEVIEW_PASSWORD='secret123' \
     -e ONEVIEW_SSL_ENABLED=true, \
     -e ONEVIEW_LOG_LEVEL='info' \
     -e ONEVIEW_API_VERSION=2000 \
     puppet-oneview puppet apply fc_network.pp --debug --trace
   ```
   To run an Image Streamer example manifests:
   ```bash
   # Note that we need an additional (I3S_URL) environment variable set
   # (Replace "plan_script" with the name of the recipe you'd like to run)
    $ docker run -it --rm \
     -v $(pwd)/:/puppet
     -e IMAGE_STREAMER_URL= 'https://imagestreamer.example.com' \
     -e IMAGE_STREAMER_API_VERSION=600 \
     -e IMAGE_STREAMER_LOG_LEVEL='info' \
     -e IMAGE_STREAMER_SSL_ENABLED=true \
     puppet-oneview puppet apply image_streamer/deployment_plan.pp --debug --trace
   ```

That's it! If you'd like to modify a manifest, simply modify the manifest file, then re-run the image.

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

## Testing
 - Style:
   - Rubocop: `$ rake rubocop`
   - Puppet Lint: `$ rake lint`
   - Metadata: `$ rake metadata_lint`
 - Unit: `$ rake spec`
 - Run all tests: `$ rake test`

 For more information please refer to the [Testing guidelines](TESTING.md).

## License

This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more information.

## Version and changes

To view history and notes for this version, view the [Changelog](CHANGELOG.md).

## Authors

- Ana Campesan - [@anazard](https://github.com/anazard)
- Chris Hurley - [@chrishpe](https://github.com/chrishpe)
- Felipe Bulsoni - [@fgbulsoni](https://github.com/fgbulsoni)
- Ricardo Piantola - [@piantola](https://github.com/piantola)
