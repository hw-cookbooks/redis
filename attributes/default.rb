#
# Cookbook Name:: redis
# Attributes:: default
#
# Copyright 2010, Atari, Inc
# Copyright 2012, CX, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# installation
default['redis']['install_type'] = "package"
default['redis']['source']['sha'] = "ac420c9f01f5e1d4e977401936f8da81d2401e65c03de2e0ca11eba1cc71c874"
default['redis']['source']['url'] = "http://redis.googlecode.com/files"
default['redis']['source']['version'] = "2.4.9"
default['redis']['src_dir'] = "/usr/src/redis"
default['redis']['dst_dir'] = "/opt/redis"
default['redis']['conf_dir'] = "/etc/redis"
default['redis']['init_style'] = "init"

# service user & group
default['redis']['user'] = "redis"
default['redis']['group'] = "redis"

# replication
default['redis']['replication']['enabled'] = false
default['redis']['replication']['redis_replication_role'] = 'master' # or slave
default['redis']['replication']['tunnel']['enabled'] = true
default['redis']['replication']['tunnel']['accept_port'] = 46379
