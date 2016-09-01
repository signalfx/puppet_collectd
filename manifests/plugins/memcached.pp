class collectd::plugins::memcached (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugin { 'memcached':
    package_name        => 'collectd-memcached',
    config_file_name    => '10-memcached.conf',
    config_template     => 'collectd/plugins/memcached/10-memcached.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
