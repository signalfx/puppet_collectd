class collectd::plugins::nginx ( $config ) {
  validate_hash($config)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'nginx':
    package_name         => 'collectd-nginx',
    plugin_file_name     => '10-nginx.conf',
    plugin_template_name => 'nginx/10-nginx.conf.erb',
  }
}
