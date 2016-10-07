class collectd::plugins::postgresql (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/postgresql/10-postgresql.conf.erb',
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'postgresql':
    package_name     => 'collectd-postgresql',
    plugin_file_name => '10-postgresql.conf',
    plugin_template  => $plugin_template,
  }
}
