# kafka plugin
#
class collectd::plugins::kafka (
  $connections,
) {
  validate_hash($connections)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  include collectd::plugins::jmx
  collectd::plugins::plugin_common { 'kafka':
    plugin_file_name     => '20-kafka.conf',
    plugin_template_name => 'kafka.conf.erb'
  }
}