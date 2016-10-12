class collectd::plugins::redis (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/redis/10-redis_master.conf.erb',
  $package_name = 'collectd-python',
  $package_ensure = present,
  $package_required = false
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

  collectd::plugins::plugin_common { 'redis':
    package_name     => $package_name,
    package_ensure   => $package_ensure,
    package_required => $package_required,
    plugin_file_name => '10-redis_master.conf',
    plugin_template  => $plugin_template,
  }
}
