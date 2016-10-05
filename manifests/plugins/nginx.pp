class collectd::plugins::nginx (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'nginx':
    package_name         => 'collectd-nginx',
    plugin_file_name     => '10-nginx.conf',
    plugin_template_name => 'nginx/10-nginx.conf.erb',
  }
}
