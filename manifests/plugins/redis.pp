class collectd::plugins::redis (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/collectd/redis-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get redis_info.py'],
  }

  file { 'get redis_info.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/redis-collectd-plugin/redis_info.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/redis/redis_info.py.erb'),
  }

  collectd::plugin { 'redis':
    package_name        => 'collectd-python',
    config_file_name    => '10-redis_master.conf',
    config_template     => 'collectd/plugins/redis/10-redis_master.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
