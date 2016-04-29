# memcached plugin
#
class collectd::plugins::memcached (
  $instances,
) {
  validate_hash($instances)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
 
  collectd::plugins::plugin_common { 'memcached':
    plugin_file_name     => "10-memcached.conf",
    plugin_template_name => 'memcached.conf.erb'
  }
}