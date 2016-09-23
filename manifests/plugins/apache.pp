class collectd::plugins::apache (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)

  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugin { 'apache':
    package_name        => 'collectd-apache',
    config_file_name    => '10-apache.conf',
    config_template     => 'collectd/plugins/apache/10-apache.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
