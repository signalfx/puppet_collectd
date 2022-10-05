class collectd::plugins::mysql (
  Hash $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/mysql/mysql.conf.erb',
  $package_name = 'collectd-mysql',
  $package_ensure = present,
  $package_required = ($::osfamily == 'RedHat')
) {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'mysql':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '10-mysql.conf',
    plugin_template     => $plugin_template,
  }
}
