class collectd::plugins::varnish (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugin { 'varnish':
    package_name        => 'collectd-varnish',
    config_file_name    => '10-varnish.conf',
    config_template     => 'collectd/plugins/varnish/10-varnish.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
