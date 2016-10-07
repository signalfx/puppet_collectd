class collectd::plugins::cassandra (
  $modules,
  $plugin_template = 'collectd/plugins/cassandra/20-cassandra.conf.erb',
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  include collectd::plugins::java

  collectd::plugins::plugin_common { 'cassandra':
    plugin_file_name => '20-cassandra.conf',
    plugin_template  => $plugin_template,
  }
}
