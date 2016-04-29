# puppet_collectd

[![Build Status](https://travis-ci.org/signalfx/puppet_collectd.svg?branch=master)](https://travis-ci.org/signalfx/puppet_collectd)

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with collectd](#setup)
    * [What collectd affects](#what-collectd-affects)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This Puppet module installs and configures the collectd from [SignalFx](http://signalfx.com), it also configures the installed collectd to send metrics to SignalFx.

With this module, you can also configure collectd plugins like collectd-rabbitmq, collectd-elasticsearch, collectd-redis etc to send metrics to SignalFx.

## Setup
```puppet
puppet module install signalfx/collectd
```

### What collectd affects

This module installs and configures collectd on your system to send various metrics to SignalFx. Be careful if you already have a working collectd. It will replace your existing collectd configuration.

## Usage

```shell
class { 'collectd' :
    signalfx_api_token  => 'YOUR_SIGNALFX_API_TOKEN'
}
```

Other valid parameters are (check the [params.pp](https://github.com/signalfx/puppet_install_collectd/blob/module_merge/manifests/params.pp) file for default values):

Parameter | Description
----------|------------
signalfx_api_token | Your SignalFx API Token
dimension_list | Set custom dimensions on all of the metrics that collectd sends to SignalFx. For example, you can use a custom dimension to indicate that one of your servers is running Kafka by including it in the hash map as follows: dimension_list => {"serverType" => "kafka"}
aws_integration | Controls AWS metadata syncing to SignalFx. Default is true.
signalfx_api_endpoint | The API endpoint to post your metrics. This will be useful if you are using a proxy.
ensure_signalfx_collectd_version | Ensures the collectd version on the system. Accepted values are of `ensure` from Puppet.
signalfx_collectd_repo_source | The source of the collectd repository from SignalFx. This will be useful when you mirror a SignalFx repository. Valid on Ubuntu and Debian systems.
signalfx_plugin_repo_source  | The source of the signalfx-collectd-plugin repository from SignalFx. This will be useful when you mirror a SignalFx repository. Valid on Ubuntu and Debian systems.
fqdnlookup | Fqdnlookup of the collectd.conf file
hostname | Hostname to be used if fqdnlookup is true, default value would be the hostname from Puppet Facter.
interval | Interval of the collectd.conf file
timeout | Timeout of the collectd.conf file
read_threads | ReadThreads of the collectd.conf file
write_queue_limit_high | WriteQueueLimitHigh of the collectd.conf file
write_queue_limit_low | WriteQueueLimitLow of the collectd.conf file
collect_internal_stats | CollectInternalStats of the collectd.conf file
log_file | The location of log file to be used by collectd
log_level | The log level to be used by collectd
write_http_timeout | Timeout option of write_http plugin
write_http_buffersize | BufferSize option of write_http plugin
write_http_flush_interval | FlushInterval option of write_http plugin
write_http_log_http_error | LogHttpError option of write_http plugin
ensure_signalfx_plugin_version | Ensures the signalfx-collectd-plugin version on the system. Accepted values are of `ensure` from Puppet.
signalfx_plugin_log_traces | LogTraces of signalfx-collectd-plugin
signalfx_plugin_interactive | Interactive option of signalfx-collectd-plugin
signalfx_plugin_notifications | Notifications option of signalfx-collectd-plugin
signalfx_plugin_notify_level | NotifyLevel option of signalfx-collectd-plugin
signalfx_plugin_dpm | DPM option of signalfx-collectd-plugin
signalfx_plugin_utilization | Utilization option of signalfx-collectd-plugin

### Supported list of plugins

We allow you to configure parameters to each plugin and they vary widely between plugins. Please check the notes under each plugin

 1. [Apache](#class-collectdpluginapache)
 2. [Cassandra](#class-collectdplugincassandra)
 3. [Docker](#class-collectdplugindocker)
 4. [Elasticsearch](#class-collectdpluginelasticsearch)
 5. [Kafka](#class-collectdpluginkafka)
 6. [Memcached](#class-collectdpluginmemcached)
 7. [Mesos-Master](#class-collectdmesos_master)
 8. [Mesos-Slave](#class-collectdpluginmesos_slave)
 9. [MongoDB](#class-collectdpluginmongodb)
 10. [MySQL](#class-collectdpluginmysql)
 11. [Nginx](#class-collectdpluginnginx)
 12. [RabbitMQ](#class-collectdpluginrabbitmq)
 13. [Redis](#class-collectdpluginredis)
 14. [Varnish](#class-collectdpluginvarnish)
 15. [Zookeeper](#class-collectdpluginzookeeper)

####Class: `collectd::plugin::apache`

```puppet
class { 'collectd::plugins:apache':
  class { 'collectd::plugins::apache':
    instances => {
      'myapacheinstance' => {
        'URL' => '"http://localhost/mod_status?auto"'
      }
    }
  }
}
```

Use [collectd-apache](https://github.com/signalfx/integrations/tree/master/collectd-apache) as a guide to configure this plugin.

####Class: `collectd::plugin::cassandra`

```puppet
class { `collectd::plugin::cassandra` :
  connections => {
    'cassandra-1' => {
      'ServiceURL' => '"service:jmx:rmi:///jndi/rmi://localhost:7199/jmxrmi"',
      'Host'       => '"<%= @hostname %>[hostHasService=cassandra]"',
      'Collect'    => ['"classes"', '"garbage_collector"',
        '"memory-heap"', '"memory-nonheap"', '"memory_pool"',
        '"cassandra-client-read-latency"',
        '"cassandra-client-read-timeouts"',
        '"cassandra-client-read-unavailables"',
        '"cassandra-client-rangeslice-latency"',
        '"cassandra-client-rangeslice-timeouts"',
        '"cassandra-client-rangeslice-unavailables"',
        '"cassandra-client-write-latency"',
        '"cassandra-client-write-timeouts"',
        '"cassandra-client-write-unavailables"',
        '"cassandra-storage-load"',
        '"cassandra-storage-hints"',
        '"cassandra-storage-hints-in-progress"',
        '"cassandra-compaction-pending-tasks"',
        '"cassandra-compaction-total-completed"']
    }
  }
}
```

Use [collectd-cassandra](https://github.com/signalfx/integrations/tree/master/collectd-cassandra) as a guide to configure this plugin

####Class: `collectd::plugin::docker`

```puppet
class { 'collectd::plugins::docker':
  modules => {
    'dockerhost1' => {
      'BaseURL' => '"unix://var/run/docker.sock"',
      'Timeout' => 3
    }
  }
}
```

Use [collectd-docker](https://github.com/signalfx/integrations/tree/master/collectd-docker) as a guide to configure this plugin

####Class: `collectd::plugin::kafka`

```puppet
class { 'collectd::plugins::kafka' :
  connections => {
    'kafka-1' => {
      'ServiceURL' => '"service:jmx:rmi:///jndi/rmi://localhost:7099/jmxrmi"',
      'Host'       => '"<%= @hostname %>[hostHasService=kafka]"',
      'Collect'    => ['"classes"', '"garbage_collector"',
        '"memory-heap"', '"memory-nonheap"', '"memory_pool"',
        '"kafka-all-messages"', '"kafka-all-bytes-in"',
        '"kafka-all-bytes-out"', '"kafka-log-flush"',
        '"kafka-active-controllers"',
        '"kafka-underreplicated-partitions"', '"kafka-request-queue"',
        '"kafka.fetch-consumer.total-time"',
        '"kafka.fetch-follower.total-time"', '"kafka.produce.total-time"']
    }
  }
}
```

####Class: `collectd::plugin::elasticsearch`

```puppet
class { 'collectd::plugins::elasticsearch':
  modules => {
    'elasticsearch-1' => {
        'Verbose'              => false,
        'Cluster'              => 'elasticsearch',
        'Indexes'              => '["_all"]',
        'EnableIndexStats'     => true,
        'EnableClusterHealth'  => true
    }
  }
}
```

Use [collectd-elasticsearch](https://github.com/signalfx/integrations/tree/master/collectd-elasticsearch) as a guide to configure this plugin

####Class: `collectd::plugin::memcached`

```puppet
class { 'collectd::plugins::kafka' :
  connections => {
    'kafka-1' => {
      'ServiceURL' => '"service:jmx:rmi:///jndi/rmi://localhost:7099/jmxrmi"',
      'Host'       => '"<%= @hostname %>[hostHasService=kafka]"',
      'Collect'    => ['"classes"', '"garbage_collector"',
        '"memory-heap"', '"memory-nonheap"', '"memory_pool"',
        '"kafka-all-messages"', '"kafka-all-bytes-in"',
        '"kafka-all-bytes-out"', '"kafka-log-flush"',
        '"kafka-active-controllers"',
        '"kafka-underreplicated-partitions"', '"kafka-request-queue"',
        '"kafka.fetch-consumer.total-time"',
        '"kafka.fetch-follower.total-time"', '"kafka.produce.total-time"']
    }
  }
}
```

Use [collectd-kafka](https://github.com/signalfx/integrations/tree/master/collectd-kafka) as a guide to configure this plugin

####Class: `collectd::plugin::memcached`

```puppet
class { 'collectd::plugin::memcached':
  class { 'collectd::plugins::memcached':
    instances => {
      'memcached-1' => {
        'Host' => '"127.0.0.1"',
        'Port' => '"11211"'
      }
    }
  }
}
```

Use [collectd-memcached](https://github.com/signalfx/integrations/tree/master/collectd-memcached) as a guide to configure this plugin

####Class: `collectd::plugin::mongodb`

```puppet
class { 'collectd::plugins::mongodb':
  modules => {
    'mongodb-1' => {
      'Host' => '"127.0.0.1"',
      'Port' => '"27017"',
      'User' => '""',
      'Password' => '"password"',
      'Database' => '"db-prod"'
    }
  }
}
```

Use [collectd-mongodb](https://github.com/signalfx/integrations/tree/master/collectd-mongodb) as a guide to configure this plugin

####Class: `collectd::plugin::mysql`

```puppet
class { 'collectd::plugins::mysql' :
  databases => {
    'mydb_plugin_instance' => {
      'Host' => 'localhost',
      'User' => 'admin',
      'Password' => 'root',
      'Database' => 'mydb',
      'Socket' => '/var/run/mysqld/mysqld.sock'
    }
  }
}
```

Use [collectd-mysql](https://github.com/signalfx/integrations/tree/master/collectd-mysql) as a guide to configure this plugin

####Class: `collectd::plugin::nginx`

```puppet
class { 'collectd::plugins::nginx' :
  config => {
    'URL' => '"http://localhost:80/nginx_status"'
  }
}
```

Use [collectd-nginx](https://github.com/signalfx/integrations/tree/master/collectd-nginx) as a guide to configure this plugin

####Class: `collectd::plugin::postgresql`

```puppet
class { 'collectd::plugins::postgresql' :
  class { 'collectd::plugins::postgresql':
    queries   => {
      'custom_deadlocks' => {
        'Statement' => '"SELECT deadlocks as num_deadlocks \
          FROM pg_stat_database \
          WHERE datname = $1;"',
        'Param'     => 'database',
        'Result'    => {
          'Type'           => '"pg_xact"',
          'InstancePrefix' => '"num_deadlocks"',
          'ValuesFrom'     => '"num_deadlocks"',
        }
      }
    },
    databases => {
      'foo' => {
        'Host'     => '"localhost"',
        'User'     => '"perf_mon"',
        'Password' => '"testpw"',
        'queries'  => ['custom_deadlocks', 'backends', 'transactions',
          'queries', 'queries_by_table', 'query_plans', 'table_states',
          'query_plans_by_table', 'table_states_by_tables', 'disk_io',
          'disk_io_by_table', 'disk_usage']
      }
    }
  }
}
```

Use [collectd-postgresql](https://github.com/signalfx/integrations/tree/master/collectd-postgresql) as a guide to configure this plugin

####Class: `collectd::plugin::rabbitmq`

```puppet
class { 'collectd::plugins::rabbitmq' :
  modules => {
    'rabbitmq-1' => {
      'Username' => '"guest"',
      'Password' => '"guest"',
      'Host' => '"localhost"',
      'Port' => '"15672"',
      'CollectChannels' => true,
      'CollectConnections' => true,
      'CollectExchanges' => true,
      'CollectNodes' => true,
      'CollectQueues' => true,
      'FieldLength' => '1024'
    }
  }
}
```

Use [collectd-rabbitmq](https://github.com/signalfx/integrations/tree/master/collectd-rabbitmq) as a guide to configure this plugin

####Class: `collectd::plugin::redis`

```puppet
class { 'collectd::plugins::redis' :
  modules => {
    '"instance_redis_master"' => {
      'Host' => '"localhost"',
      'Port' => 6379,
      'Verbose' => 'false',
      'Redis_uptime_in_seconds' => '"gauge"',
      'Redis_used_cpu_sys' => '"counter"',
      'Redis_used_cpu_user' => '"counter"',
      'Redis_used_cpu_sys_children' => '"counter"',
      'Redis_used_cpu_user_children' => '"counter"',
      'Redis_uptime_in_days' => '"gauge"',
      'Redis_lru_clock' => '"counter"',
      'Redis_connected_clients' => '"gauge"',
      'Redis_connected_slaves' => '"gauge"',
      'Redis_client_longest_output_list' => '"gauge"',
      'Redis_client_biggest_input_buf' => '"gauge"',
      'Redis_blocked_clients' => '"gauge"',
      'Redis_expired_keys' => '"counter"',
      'Redis_evicted_keys' => '"counter"',
      'Redis_rejected_connections' => '"counter"',
      'Redis_used_memory' => '"bytes"',
      'Redis_used_memory_rss' => '"bytes"',
      'Redis_used_memory_peak' => '"bytes"',
      'Redis_used_memory_lua' => '"bytes"',
      'Redis_mem_fragmentation_ratio' => '"gauge"',
      'Redis_changes_since_last_save' => '"gauge"',
      'Redis_instantaneous_ops_per_sec' => '"gauge"',
      'Redis_rdb_bgsave_in_progress' => '"gauge"',
      'Redis_total_connections_received' => '"counter"',
      'Redis_total_commands_processed' => '"counter"',
      'Redis_total_net_input_bytes' => '"counter"',
      'Redis_total_net_output_bytes' => '"counter"',
      'Redis_keyspace_hits' => '"derive"',
      'Redis_keyspace_misses' => '"derive"',
      'Redis_latest_fork_usec' => '"gauge"',
      'Redis_connected_slaves' => '"gauge"',
      'Redis_repl_backlog_first_byte_offset' => '"gauge"',
      'Redis_master_repl_offset' => '"gauge"',
      'Redis_db0_keys' => '"gauge"',
      'Redis_db0_expires' => '"gauge"',
      'Redis_db0_avg_ttl' => '"gauge"'
    }
  }
}
```

Use [collectd-redis](https://github.com/signalfx/integrations/tree/master/collectd-redis) as a guide to configure this plugin.

####Class: `collectd::plugin::varnish`

```puppet
class { 'collectd::plugins::varnish':
  config => {
    'CollectCache'       => 'true',
    'CollectConnections' => 'true',
    'CollectBackend'     => 'true',
    'CollectSHM'         => 'true',
    'CollectESI'         => 'true',
    'CollectFetch'       => 'true',
    'CollectHCB'         => 'true',
    'CollectSMA'         => 'true',
    'CollectSMS'         => 'true',
    'CollectSM'          => 'true',
    'CollectTotals'      => 'true',
    'CollectWorkers'     => 'true',
    'CollectUptime'      => 'true',
    'CollectVCL'         => 'true',
    'CollectStruct'      => 'true',
    'CollectObjects'     => 'true',
    'CollectSession'     => 'true',
    'CollectVSM'         => 'true'
  }
}
```

Use [collectd-varnish](https://github.com/signalfx/integrations/tree/master/collectd-varnish) as a guide to configure this plugin

####Class: `collectd::plugin::zookeeper`

```puppet
class { 'collectd::plugins::zookeeper':
  modules => {
    'zookeeper-1' => {
      'Hosts'    => '"localhost"',
      'Port'     => '2181',
      'Instance' => '"zk-cluster-0"'
    }
  }
}
```

Use [collectd-zookeeper](https://github.com/signalfx/integrations/tree/master/collectd-zookeeper) as a guide to configure this plugin

## Limitations

Currently, the supported operating systems are 
  1. Ubuntu 12.04
  2. Ubuntu 14.04
  3. Ubuntu 15.04
  4. CentOS 6
  5. CentOS 7
  6. Amazon Linux 2014.09
  7. Amazon Linux 2015.03
  8. Amazon Linux 2015.09
  9. Debian GNU/Linux 7 (wheezy)
  10. Debian GNU/Linux 8 (jessie)
