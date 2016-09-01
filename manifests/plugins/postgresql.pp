class collectd::plugins::postgresql (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugin { 'postgresql':
    package_name        => 'collectd-postgresql',
    config_file_name    => '10-postgresql.conf',
    config_template     => 'collectd/plugins/postgresql/10-postgresql.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
