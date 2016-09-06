class collectd::plugins::memcached ( $modules ) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'memcached':
    package_name         => 'collectd-memcached',
    plugin_file_name     => '10-memcached.conf',
    plugin_template_name => 'memcached/10-memcached.conf.erb',
  }
}

