# DESCRIPTION:

Installs and configures [Redis](http://redis.io/).

** NOTE **
This cookbook does not currently configure or manage Redis replication.

# REQUIREMENTS:

The Redis cookbook has been tested on Ubuntu 10.04, 11.04, 11.10, 12.04, Debian 6.0, and CentOS 5 and 6.

## Cookbooks:

* [yum](https://github.com/opscode-cookbooks/yum) - Used to install Redis package from EPEL repo on CentOS/Redhat.
* [build-essential](https://github.com/opscode-cookbooks/build-essential) - Used when compiling Redis.
* [runit](https://github.com/opscode-cookbooks/runit) - Used only if Redis is configured to start with Runit.

# ATTRIBUTES:

## Installation:
* `['redis']['install_type']` - Install the Package by default. [ package, source ]
* `['redis']['source']['sha']` - The sha256 checksum of the source tarball.
* `['redis']['source']['url']` - The url to the source tarball.
* `['redis']['source']['version']` - The version of Redis to install.
* `['redis']['src_dir']` - Extract the Redis source to this directory.
* `['redis']['dst_dir']` - Install compiled Redis to this directory.
* `['redis']['conf_dir']` - The Redis configuration directory.
* `['redis']['init_style']` - A value of "init" is currently recommended, but full runit support is coming soon.

## Configuration:

The configuration file is dynamically built from the config hash. Keys are
used as the configuration name, and values used for their values. In cases
where a configuration name may be used multiple times, the multiple values
can be stored in an array value to generate the proper configuration. Since
valid configuration values change depending on version, the the `_server_config_defaults`
recipe is used to set defaults based on version installed.

* Config reference: https://github.com/antirez/redis/blob/unstable/redis.conf

## Replication

Replication can be enabled by adding the `replication` recipe to the run list and
specifying the node's role. For the master node:

```ruby
name 'redis_master'
run_list('role[redis]', 'recipe[redis::replication]')
override_attributes(
  :redis => {
    :replication => {
      :enabled => true,
      :redis_replication_role => 'master'
    }
  }
)
```
and for the slave:
```ruby
name 'redis_slave'
run_list('role[redis]', 'recipe[redis::replication]')
override_attributes(
  :redis => {
    :replication => {
      :enabled => true,
      :redis_replication_role => 'slave'
    }
  }
)
```
Since there may be times where replication is happening outside of a secure network,
an SSL tunnel can be setup for replication:
```ruby
name 'redis_replication'
run_list('role[redis]', 'recipe[redis::replication]')
override_attributes(
  :redis => {
    :replication => {
      :enabled => true,
      :tunnel => {
        :enabled => true
      }
    }
  }
)
```
## Sentinel
Sentinel support can be enabled to allow for automatic failover. It is builtin to
Redis and available in 2.6. It requires replication to be enabled and is not
compatible with tunneled replication, so should be used within a secure environment.
To enable sentinel, simply add it to the run list:

```ruby
run_list('role[redis]', 'recipe[redis::sentinel]')
```

# USAGE:

There are several recipes broken up into reusable pieces. For ease of use, we've also included wrappers that map the most common use.

* `redis::_group` - Creates a group for Redis.
* `redis::_server_config` - Creates configuration directories and installs templatized redis.conf.
* `redis::_server_init` - Installs a templatized Redis sysv initscript.
* `redis::_server_install_from_package` - Installs Redis through the chef package resource.
* `redis::_server_install_from_package` - Downloads, compiles, and installs Redis from source.
* `redis::_server_runit` - Installs templatized Redis runit configuration.
* `redis::_server_service` - Configures Redis through the chef service resource.
* `redis::_user` - Creates a user for Redis.
* `redis::default` - The default recipe executes the redis::server_package recipe.
* `redis::server` - The default recipe executes the redis::server_package recipe. This recipe is here for compatibility with other community Redis cookbooks.
* `redis::server_package` - Uses the recipe crumbs in the Redis cookbook to manage a packaged Redis instance.
* `redis::server_source` - Uses the recipe crumbs in the Redis cookbook to manage a source compiled Redis instance.
* `redis::replication` - Configure master and slave nodes for replication
* `redis::sentinel` - Setup sentinel for monitoring cluster

# CONTRIBUTE:

Please feel free to add issues, and submit pull requests to our [github](https://github.com/CXInc/chef-redis)!

# LICENSE & AUTHOR:
Author:: Miah Johnson (<miah@cx.com>)
Copyright:: 2012, CX, Inc
Author:: Noah Kantrowitz (<nkantrowitz@crypticstudios.com>)
Copyright:: 2010, Atari, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
