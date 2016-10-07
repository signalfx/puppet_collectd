class collectd::plugins::apache (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/apache/10-apache.conf.erb',
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'apache':
    package_name     => 'collectd-apache',
    plugin_file_name => '10-apache.conf',
    plugin_template  => $plugin_template,
  }
}
