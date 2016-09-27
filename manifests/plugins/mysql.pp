class collectd::plugins::mysql (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'mysql':
    package_name         => 'collectd-mysql',
    plugin_file_name     => '10-mysql.conf',
    plugin_template_name => 'mysql/mysql.conf.erb'
  }
}
