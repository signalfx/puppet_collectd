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
puppet module install signalfx/collectd (not released on PuppetForge yet!)
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

 1. [Elasticsearch](#class-collectdpluginelasticsearch)
 2. [MySQL](#class-collectdpluginmysql)
 3. [RabbitMQ](#class-collectdpluginrabbitmq)
 4. [Redis](#class-collectdpluginredis)

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
See [collectd-elasticsearch](https://github.com/signalfx/collectd-elasticsearch) for configurable parameters. 
The sample output file generated would look like [10-elasticsearch.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/20-elasticsearch.conf). Currently, the plugin only monitors one elasticsearch instance, so you should include only one module in the above class arguments. The plugin code will be updated very soon to monitor multiple elasticsearch instances.

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

See [collectd.conf](https://collectd.org/documentation/manpages/collectd.conf.5.shtml) for configurable parameters. 
The sample output file generated would look like [10-mysql.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/10-mysql.conf)

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
The sample output file generated would look like [10-rabbitmq.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/10-rabbitmq.conf). Currently, the plugin only monitors one rabbitmq instance, so you should include only one module in the above class arguments. The plugin code will be updated very soon to monitor multiple rabbitmq instances.

####Class: `collectd::plugin::redis`

```puppet
class { 'collectd::plugins::redis' :
  modules => {
    'instance_redis_master' => {
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

See [redis-collectd-plugin](https://github.com/signalfx/redis-collectd-plugin) for configurable parameters. 
The sample output file generated would look like [10-redis_master.conf](https://github.com/signalfx/signalfx-collectd-configs/blob/master/managed_config/10-redis_master.conf)

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
