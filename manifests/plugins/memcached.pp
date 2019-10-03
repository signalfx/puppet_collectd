class collectd::plugins::memcached (
  Hash $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/memcached/10-memcached.conf.erb',
  $package_name = 'UNSET',
  $package_ensure = present,
  $package_required = false
) {
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'memcached':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '10-memcached.conf',
    plugin_template     => $plugin_template,
  }
}
