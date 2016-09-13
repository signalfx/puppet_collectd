class collectd::plugins::postgresql (
  $databases,
  $filter_metrics = false,
  $filter_metric_rules = {} ) {
  validate_hash($databases)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'postgresql':
    package_name         => 'collectd-postgresql',
    plugin_file_name     => '10-postgresql.conf',
    plugin_template_name => 'postgresql/10-postgresql.conf.erb',
  }
}
