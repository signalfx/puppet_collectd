Release 0.1.10
  * Rename collectd::plugins::plugin_common to collectd::plugin
  * Enable custom template location for plugins
  * Standardized plugin configuration templates to use 'modules' as the config parameter

Release 0.1.9
  * Fix for vmstat plugin to support RHEL

Release 0.1.7
  * Add ability to filter on plugin-specific metrics
  * Add vmstat plugin
  * Change nginx plugin usage
  * Update docker plugin to v1.0.0 release
  * Update elatsicsearch plugin and configuration to 1.2.0 release.

Release 0.1.6
  * Add ability to configure plugin-specific reporting intervals
  * Add iostat plugin
  * Add memcached plugin
  * Add varnish plugin
  * Update signalfx metadata plugin to support optionally reporting cpu utilization on a per-core basis

Release 0.1.5
  * Add Apache Httpd plugin
  * Add Apache Cassandra plugin
  * Add Docker plugin
  * Update Elasticsearch plugin
  * Add Java (supporting) plugin
  * Add Apache Kafka plugin
  * Add Apache Mesos (master) plugin
  * Add Mongodb plugin
  * Add Nginx plugin
  * Add Postgresql plugin
  * Update Redis plugin
  * Add Apache Zookeeper plugin

Release 0.1.4
  * Support Amazon Linux 2016.03

Release 0.1.3
  * Fix file permissions
  * Revert network unreachable error fix, its not module's error

Release 0.1.2
  * Fix network unreachable error on non AWS puppetmaster

Release 0.1.1
  * Update version of stdlib to support apt

Release 0.1.0

  * Merge three modules into one module
  * Add aggregation, Elasticsearch, Mysql, Rabbitmq, Redis plugin
  * Configurable parameters to each plugin
