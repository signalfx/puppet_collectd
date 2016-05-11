# varnish plugin
#
class collectd::plugins::varnish (
  $config,
) {
  validate_hash($config)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  collectd::plugins::plugin_common { 'varnish':
    package_name         => 'collectd-varnish',
    plugin_file_name     => '10-varnish.conf',
    plugin_template_name => 'varnish.conf.erb'
  }
}