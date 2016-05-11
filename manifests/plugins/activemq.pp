# activemq plugin
#
class collectd::plugins::activemq (
  $connections,
) {
  validate_hash($connections)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
 
  include collectd::plugins::jmx
  collectd::plugins::plugin_common { 'activemq':
    plugin_file_name     => '20-activemq.conf',
    plugin_template_name => 'activemq.conf.erb'
  }
}