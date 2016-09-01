class collectd::plugins::nginx (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugin { 'nginx':
    package_name        => 'collectd-nginx',
    config_file_name    => '10-nginx.conf',
    config_template     => 'collectd/plugins/nginx/10-nginx.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
