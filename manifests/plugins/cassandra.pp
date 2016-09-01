class collectd::plugins::cassandra (
  $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  include collectd::plugins::java

  collectd::plugin { 'cassandra':
    package_name     => 'collectd-cassandra',
    config_file_name => '20-cassandra.conf',
    config_template  => 'collectd/plugins/cassandra/20-cassandra.conf.erb',
    modules          => $modules,
  }
}
