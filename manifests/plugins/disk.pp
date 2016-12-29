class collectd::plugins::disk (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/df/10-disk.conf.erb',
  $package_name = 'UNSET',
  $package_ensure = present,
  $package_required = false
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'disk':
    package_name     => $package_name,
    package_ensure   => $package_ensure,
    package_required => $package_required,
    plugin_file_name => '10-disk.conf',
    plugin_template  => $plugin_template,
  }
}
