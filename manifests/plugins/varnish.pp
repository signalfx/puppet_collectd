class collectd::plugins::varnish (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/varnish/10-varnish.conf.erb',
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'varnish':
    package_name     => 'collectd-varnish',
    plugin_file_name => '10-varnish.conf',
    plugin_template  => $plugin_template,
  }
}
