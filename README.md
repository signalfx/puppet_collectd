# puppet_collectd

[![Build Status](https://travis-ci.org/signalfx/puppet_collectd.svg?branch=master)](https://travis-ci.org/signalfx/puppet_collectd)

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with collectd](#setup)
    * [What collectd affects](#what-collectd-affects)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Supported Platforms](#supported-platforms)

## Overview

This Puppet module installs the collectd from [SignalFx](https://github.com/signalfx/collectd). It also configures the installed collectd to send metrics to SignalFx.

With this module you can also configure collectd plugins (e.g. collectd-rabbitmq, collectd-elasticsearch, collectd-redis, etc.) to send metrics to SignalFx.

## Setup
```puppet
puppet module install signalfx/collectd
```

### What collectd affects

This module installs and configures collectd on your system to send various metrics to SignalFx. Be careful if you already have a working collectd as it will replace your existing collectd configuration.

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
use_default_cpu_plugin | Cpu default plugin option. Set to false to disable default cpu plugin
use_default_cpufreq_plugin | Cpufreq default plugin option. Set to false to disable default cpufreq plugin
use_default_df_plugin | Df default plugin option. Set to false to disable default df plugin
use_default_disk_plugin | Disk default plugin option. Set to false to disable default disk plugin
use_default_interface_plugin | Interface default plugin option. Set to false to disable default interface plugin
use_default_load_plugin | Load default plugin option. Set to false to disable default load plugin
use_default_memory_plugin | Memory default plugin option. Set to false to disable default memory plugin
use_default_protocols_plugin | Protocols default plugin option. Set to false to disable default protocols plugin
use_default_vmem_plugin | Vmem default plugin option. Set to false to disable default vmem plugin
use_default_uptime_plugin | Uptime default plugin option. Set to false to disable default uptime plugin
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
signalfx_plugin_cpu_utilization | CPU Utilization option of signalfx-collectd-plugin
signalfx_plugin_cpu_utilization_per_core | CPU Utilization for individual cores option of signalfx-collectd-plugin

### Plugin Interval

You can set the plugin-specific interval for collecting metrics.  This overrides the global interval setting.
The following example sets the interval for the cpu and disk plugins to 1 second.

```puppet
class { 'collectd' :
    signalfx_api_token  => 'YOUR_SIGNALFX_API_TOKEN',
    loadplugins => {
        'cpu' => {
          'Interval' => 1
        },
        'disk' => {
          'Interval' => 1
        }
    }
}
```

### Metric Filtering

#### Plugin Metric Filtering

You can control which plugin-specific metrics are sent to SignalFx using collectd filtering.

The basic usage is to set *filter_metrics* to true and then add rules to *filter_metric_rules* based on *Type* and/or *TypeInstance*.
A rule's name can be anything, Type must be the complete name of type, and TypeInstance can be a regular expression.

```puppet
filter_metrics => true,
filter_metric_rules => {
  'some_rule_name' => {
    'Type' => 'some_type',
    'TypeInstance' => '^some_type_instance*'
  }
}
```

The following example filters the metrics sent from the mysql plugin for all types of "mysql_octets" and also the "threads.running" metric.

```puppet
class { 'collectd::plugins::mysql' :
  modules => {
    'mydb_plugin_instance' => {
      'Host' => '"localhost"',
      'User' => '"admin"',
      'Password' => '"root"',
      'Database' => '"mydb"',
      'Socket' => '"/var/run/mysqld/mysqld.sock"'
    }
  },
  filter_metrics => true,
  filter_metric_rules => {
  'Mysql-Octets-Whitelist' => {
     'Type' => 'mysql_octets'
   },
   'Mysql-RunningThreads-Whitelist' => {
      'Type' => 'threads',
      'TypeInstance' => 'running'
    }
  }
}
```

__Note:__ This feature is not available for java plugins which use their own mbean filtering technique.

#### Default Plugin Metric Filtering

You can also control which default plugin metrics are sent to SignalFx using collectd filtering.
See the collectd.conf template for the list of default plugins.

The basic usage is to set *filter_default_metrics* to true and then add rules to *filter_default_metric_rules* for one or more plugins based on *Type* and/or *TypeInstance*.
The plugin and rule names are required. The Type must be the complete name of type, and TypeInstance can be a regular expression.

```puppet
filter_default_metrics => true,
filter_default_metric_rules => {
  'plugin_name' => {
    'rule_name' => {
      'Type' => 'some_type',
      'TypeInstance' => '^some_type_instance*'
    }
  }
}
```

The following example applies a filter to the default vmem plugin so that only *vmpage_io.swap.in* and *vmpage_io.swap.out* metrics are sent.

```puppet
class { 'collectd' :
  signalfx_api_token  => 'YOUR_SIGNALFX_API_TOKEN',
  filter_default_metrics => true,
  filter_default_metric_rules => {
    'vmem' => {
      'whitelist_vmpage_io' => {
        'Type' => 'vmpage_io',
        'TypeInstance' => '^swap*'
      }
    }
  }
}
```

__Note:__ This feature will override any default filters in the filtering.conf file.

### Supported list of plugins

You may specify parameters on a per-plugin basis. Please check the notes under each plugin.

 1.  [Apache](#class-collectdpluginapache)
 2.  [Cassandra](#class-collectdplugincassandra)
 3.  [Df](#class-collectdplugindf)
 4.  [Disk](#class-collectdplugindisk)
 5.  [Docker](#class-collectdplugindocker)
 6.  [Elasticsearch](#class-collectdpluginelasticsearch)
 7.  [HAProxy](#class-collectdpluginhaproxy)
 8.  [Iostat](#class-collectdpluginiostat)
 9.  [Kafka](#class-collectdpluginkafka)
 10. [Memcached](#class-collectdpluginmemcached)
 11. [Mesos](#class-collectdpluginmesos)
 12. [MongoDB](#class-collectdpluginmongodb)
 13. [MySQL](#class-collectdpluginmysql)
 14. [Nginx](#class-collectdpluginnginx)
 15. [Postgresql](#class-collectdpluginpostgresql)
 16. [RabbitMQ](#class-collectdpluginrabbitmq)
 17. [Redis](#class-collectdpluginredis)
 18. [Varnish](#class-collectdpluginvarnish)
 19. [Vmstat](#class-collectdpluginvmstat)
 20. [Zookeeper](#class-collectdpluginzookeeper)


####Class: `collectd::plugin::apache`

```puppet
class { 'collectd::plugins::apache':
  modules => {
    'myinstance' => {
        'URL' => '"http://localhost/mod_status?auto"',
    }
  }
}
```

See [collectd-apache](https://github.com/signalfx/integrations/tree/master/collectd-apache) for configurable parameters and apache configuration instructions.

####Class: `collectd::plugin::cassandra`

```puppet
class { 'collectd::plugins::cassandra' :
  modules => {
    'connection1' => {
      'ServiceURL' => '"service:jmx:rmi:///jndi/rmi://localhost:7199/jmxrmi"',
      'Host' => '"testcassandraserver[hostHasService=cassandra]"',
      'collect_metrics' => [
        'classes',
        'garbage_collector',
        'memory-heap',
        'memory-nonheap',
        'memory_pool',
        'threading',
        'cassandra-client-read-latency',
        'cassandra-client-read-timeouts',
        'cassandra-client-read-unavailables',
        'cassandra-client-rangeslice-latency',
        'cassandra-client-rangeslice-timeouts',
        'cassandra-client-rangeslice-unavailables',
        'cassandra-client-write-latency',
        'cassandra-client-write-timeouts',
        'cassandra-client-write-unavailables',
        'cassandra-storage-load',
        'cassandra-storage-hints',
        'cassandra-storage-hints-in-progress',
        'cassandra-compaction-pending-tasks',
        'cassandra-compaction-total-completed',
      ]
    }
  }
}
```

See [collectd-cassandra](https://github.com/signalfx/integrations/tree/master/collectd-cassandra) for configurable parameters.

####Class: `collectd::plugin::df`

__Note:__ This plugin is automatically included with a default configuration. You need to disable the use of the default df plugin before adding this configuration (see use_default_df_plugin in collectd parameters).

```puppet
class { 'collectd::plugins::df':
  modules => {
    'config' => {
      'ReportInodes'  => 'true',
      'FSType'  => '"tmpfs"',
      'FSType'  => '"devtmpfs"',
      'IgnoreSelected'  => 'true',
    }
  }
}
```

See [collectd-df](https://github.com/signalfx/integrations/tree/master/collectd-df) for configurable parameters and df configuration instructions.

####Class: `collectd::plugin::disk`

__Note:__ This plugin is automatically included with a default configuration. You need to disable the use of the default disk plugin before adding this configuration (see use_default_disk_plugin in collectd parameters).

```puppet
class { 'collectd::plugins::disk':
  modules => {
    'config' => {
      'Disk'  => '"sda"',
      'IgnoreSelected'  => 'false',
    }
  }
}
```

See [collectd-disk](https://github.com/signalfx/integrations/tree/master/collectd-disk) for configurable parameters and disk configuration instructions.

####Class: `collectd::plugin::docker`

```puppet
class { 'collectd::plugins::docker':
  modules => {
    'dockerplugin' => {
        'BaseURL'              => '"unix://var/run/docker.sock"',
        'Timeout'              => '3',
        'Verbose'              => false
    }
  },
  filter_metrics => true,
  filter_metric_rules => {
    'CpuUsage' => {
       'Type' => 'cpu.usage'
     },
    'MemoryUsage' => {
       'Type' => 'memory.usage'
    },
    'NetworkUsage' => {
       'Type' => 'network.usage'
    },
    'BlockIO' => {
       'Type' => 'blkio',
       'TypeInstance' => '^io_service_bytes_recursive-.*'
    }
  }
}
```

See [collectd-docker](https://github.com/signalfx/integrations/tree/master/collectd-docker) for configurable parameters.

####Class: `collectd::plugin::elasticsearch`

```puppet
class { 'collectd::plugins::elasticsearch':
  modules => {
    'elasticsearch_collectd' => {
        'Verbose'              => false,
        'Cluster'              => '"elasticsearch"',
        'Indexes'              => '["_all"]',
        'EnableIndexStats'     => true,
        'EnableClusterHealth'  => true,
        'Interval'             => 10,
        'IndexInterval'        => 300,
        'DetailedMetrics'      => false,
        'ThreadPools'          => '["search","index"]',
        'AdditionalMetrics'    => '[""]',
    }
  }
}
```
See [collectd-elasticsearch](https://github.com/signalfx/collectd-elasticsearch) for configurable parameters.
The sample output file generated would look like [20-elasticsearch.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/20-elasticsearch.conf). Currently, the plugin only monitors one elasticsearch instance, so you should include only one module in the above class arguments.

####Class: `collectd::plugin::kafka`

```puppet
class { 'collectd::plugins::kafka' :
  modules => {
    'connection1' => {
      'ServiceURL' => '"service:jmx:rmi:///jndi/rmi://localhost:7099/jmxrmi"',
      'Host' => '"testkafkaserver[hostHasService=kafka]"',
      'collect_metrics' => [
        'classes',
        'garbage_collector',
        'memory-heap',
        'memory-nonheap',
        'memory_pool',
        'threading',
        'kafka-all-messages',
        'kafka-all-bytes-in',
        'kafka-all-bytes-out',
        'kafka-log-flush',
        'kafka-active-controllers',
        'kafka-underreplicated-partitions',
        'kafka-request-queue',
        'kafka.fetch-consumer.total-time',
        'kafka.fetch-follower.total-time',
        'kafka.produce.total-time',
      ]
    }
  }
}
```

See [collectd-kafka](https://github.com/signalfx/integrations/tree/master/collectd-kafka) for configurable parameters.

####Class: `collectd::plugin::iostat`

```puppet
class { 'collectd::plugins::iostat':
  modules => {
    'collectd_iostat_python' => {
        'Path' => '"/usr/bin/iostat"',
        'Verbose' => false,
        'Include' => '["tps", "kB_read/s", "kB_wrtn/s", "kB_read", "kB_wrtn", "rrqm/s", "wrqm/s", "r/s", "w/s", "rsec/s", "rkB/s", "wsec/s", "wkB/s", "avgrq-sz", "avgqu-sz", "await", "r_await", "w_await", "svctm", "%util"]'
    }
  }
}
```
See [collectd-iostat](https://github.com/signalfx/integrations/tree/master/collectd-iostat) for configurable parameters.

####Class: `collectd::plugin::memcached`

```puppet
class { 'collectd::plugins::memcached':
  modules => {
    'config' => {
      'Host'  => '"127.0.0.1"',
      'Port'  => '"11211"'
    }
  }
}
```


See [collectd-haproxy](https://github.com/signalfx/integrations/blob/master/collectd-haproxy/10-haproxy.conf) for configurable parameters.

####Class: `collectd::plugin::haproxy`

```puppet
class { 'collectd::plugins::haproxy':
  version => 'v1.0.1',
  modules => {
    'config' => {
      'Socket'  => '/var/lib/haproxy/stats',
      'ProxyMonitor'  => ['backend',  'http-in',  'server1'],
      'ExcludeMetric' => ['session_limit', 'response_1xx'],
    }
  }
}
```

See [collectd-memcached](https://github.com/signalfx/integrations/tree/master/collectd-memcached) for configurable parameters and memcached configuration instructions.

####Class: `collectd::plugin::mesos`

```puppet
class { 'collectd::plugins::mesos' :
  modules => {
    'mesos-master' => {
      'Cluster' => '"cluster-0"',
      'Instance' => '"master-0"',
      'Path' => '"/usr/sbin"',
      'Host' => '"localhost"',
      'Port' => '5050',
      'Verbose' => 'false',
    }
  }
}
```
See [collectd-mesos](https://github.com/signalfx/integrations/tree/master/collectd-mesos) for configurable parameters.

####Class: `collectd::plugin::mongodb`

```puppet
class { 'collectd::plugins::mongodb' :
  modules => {
    'module1' => {
      'Host' => '"localhost"',
      'Port' => '"27017"',
      'User' => '"collectd"',
      'Password' => '"password"',
      'Database' => '"db1"',
    },
    'module2' => {
      'Host' => '"localhost"',
      'Port' => '"27017"',
      'Database' => '"test"',
    }
  }
}
```
See [collectd-mongodb](https://github.com/signalfx/integrations/tree/master/collectd-mongodb) for configurable parameters.

####Class: `collectd::plugin::mysql`

```puppet
class { 'collectd::plugins::mysql' :
  modules => {
    'mydb_plugin_instance' => {
      'Host' => '"localhost"',
      'User' => '"admin"',
      'Password' => '"root"',
      'Database' => '"mydb"',
      'Socket' => '"/var/run/mysqld/mysqld.sock"'
    }
  }
}
```

See [collectd.conf](https://collectd.org/documentation/manpages/collectd.conf.5.shtml) for configurable parameters.
The sample output file generated would look like [10-mysql.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/10-mysql.conf)

####Class: `collectd::plugin::nginx`

```puppet
class { 'collectd::plugins::nginx':
  modules => {
    'config' => {
      'URL'  => '"http://localhost:80/nginx_status"',
    }
  }
}
```

See [collectd-nginx](https://github.com/signalfx/integrations/tree/master/collectd-nginx) for configurable parameters and nginx configuration instructions.

####Class: `collectd::plugin::postgresql`

```puppet
class { 'collectd::plugins::postgresql' :
  modules => {
    'database1' => {
      'Host' => '"127.0.0.1"',
      'User' => '"postgres"',
      'Password' => '"password"',
      'queries' => [
        'custom_deadlocks',
        'backends',
        'transactions',
        'queries',
        'queries_by_table',
        'query_plans',
        'table_states',
        'query_plans_by_table',
        'table_states_by_table',
        'disk_io',
        'disk_io_by_table',
        'disk_usage',
      ]
    }
  }
}
```

See [collectd-postgresql](https://github.com/signalfx/integrations/tree/master/collectd-postgresql) for configurable parameters.

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

See [collectd-rabbitmq](https://github.com/signalfx/collectd-rabbitmq) for configurable parameters.
The sample output file generated would look like [10-rabbitmq.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/10-rabbitmq.conf). Currently, the plugin only monitors one rabbitmq instance, so you should include only one module in the above class arguments.

####Class: `collectd::plugin::redis`

```puppet
class { 'collectd::plugins::redis' :
  modules => {
    'redis_info' => {
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
    }
  }
}
```

See [redis-collectd-plugin](https://github.com/signalfx/redis-collectd-plugin) for configurable parameters.
The sample output file generated would look like [10-redis_master.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/10-redis_master.conf)

####Class: `collectd::plugin::varnish`

```puppet
class { 'collectd::plugins::varnish' :
  modules => {
    'instance' => {
      'CollectCache' => true,
      'CollectConnections' => true,
      'CollectBackend' => true,
      'CollectSHM' => true,
      'CollectESI' => true,
      'CollectFetch' => true,
      'CollectHCB' => true,
      'CollectSMA' => true,
      'CollectSMS' => true,
      'CollectSM' => true,
      'CollectTotals' => true,
      'CollectWorkers' => true,
      'CollectUptime' => true,
      'CollectVCL' => true,
      'CollectStruct' => true,
      'CollectObjects' => true,
      'CollectSession' => true,
      'CollectVSM' =>true
    }
  }
}
```

See [collectd-varnish](https://github.com/signalfx/integrations/tree/master/collectd-varnish) for configurable parameters.

####Class: `collectd::plugin::vmstat`

```puppet
class { 'collectd::plugins::vmstat':
  modules => {
    'vmstat_collectd' => {
        'Path' => '"/usr/bin/vmstat"',
        'Verbose' => false,
        'Include' => '["r", "b", "swpd", "free", "buff", "cache", "inact", "active", "si", "so", "bi", "bo", "in", "cs", "us", "sy", "id", "wa", "st"]'
    }
  }
}
```
See [collectd-vmstat](https://github.com/signalfx/integrations/tree/master/collectd-vmstat) for configurable parameters.

####Class: `collectd::plugin::zookeeper`

```puppet
class { 'collectd::plugins::zookeeper' :
  modules => {
    'module' => {
      'Hosts' => '"localhost"',
      'Port' => '2181',
    }
  }
}
```
See [collectd-zookeeper](https://github.com/signalfx/integrations/tree/master/collectd-zookeeper) for configurable parameters.

## Supported Platforms

Currently, the supported platforms for this module are:
  1.  Ubuntu 12.04
  2.  Ubuntu 14.04
  3.  Ubuntu 15.04
  4.  Ubuntu 16.04
  5.  CentOS 6
  6.  CentOS 7
  7.  RHEL 6
  8.  RHEL 7
  9.  Amazon Linux 2014.09
  10. Amazon Linux 2015.03
  11. Amazon Linux 2015.09
  12. Amazon Linux 2016.03
  12. Amazon Linux 2016.09
  12. Amazon Linux 2017.03
  12. Amazon Linux 2017.09
  13. Debian GNU/Linux 7 (wheezy)
  14. Debian GNU/Linux 8 (jessie)
  15. Debian GNU/Linux 9 (stretch)
