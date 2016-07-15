class collectd::plugins::cassandra ( $connections ) {
  validate_hash($connections)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  include collectd::plugins::java

  collectd::plugins::plugin_common { 'cassandra':
    plugin_file_name     => '20-cassandra.conf',
    plugin_template_name => 'cassandra/20-cassandra.conf.erb',
  }
}
