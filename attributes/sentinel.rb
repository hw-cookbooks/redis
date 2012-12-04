default[:redis][:sentinel][:port] = 26379
default[:redis][:sentinel][:quorum] = 2
default[:redis][:sentinel][:down_after] = 60000
default[:redis][:sentinel][:failover_timeout] = 900000
default[:redis][:sentinel][:can_failover] = true
default[:redis][:sentinel][:parallel_syncs] = 1
default[:redis][:sentinel][:config][:daemonize] = true
default[:redis][:sentinel][:config][:pidfile] = "/var/run/redis/redis-sentinel.pid"
