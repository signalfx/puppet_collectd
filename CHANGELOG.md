Release 0.1.14
  * Fixing typo in collectd disk plugin manifest

Release 0.1.13
  * Adding support for Amazon Linux 2016.09, 2017.03, and 2017.09

Release 0.1.12
  * Fix for plugin modules configuration

Release 0.1.11
  * Add ability to disable individual default plugins
  * Add df plugin as custom configurable
  * Add disk plugin as custom configurable

Release 0.1.10
  * Allow setting github repo revision to pull from in get_from_github
  * Standardize all plugin templates to use modules parameter
  * Introduce ability to set template location
  * Introduce ability to set package version and use

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
  * Add apache plugin
  * Add cassandra plugin
  * Add docker plugin
  * Update elasticsearch plugin
  * Add java (supporting) plugin
  * Add kafka plugin
  * Add mesos (master) plugin
  * Add mongodb plugin
  * Add nginx plugin
  * Add postgresql plugin
  * Update redis plugin
  * Add zookeeper plugin

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
  * Add aggregation, elasticsearch, mysql, rabbitmq, redis plugin
  * Configurable parameters to each plugin
