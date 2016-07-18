class collectd::plugins::redis ( $modules ) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/', '/usr/share/collectd/', '/usr/share/collectd/redis-collectd-plugin/']:
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
    package_name         => 'collectd-python',
    plugin_file_name     => '10-redis_master.conf',
    plugin_template_name => 'redis/10-redis_master.conf.erb',
  }
}
