class collectd::plugins::kafka (
  $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  include collectd::plugins::java

  collectd::plugin { 'kafka':
    package_name     => 'collectd-kafka',
    config_file_name => '20-kafka.conf',
    config_template  => 'collectd/plugins/kafka/20-kafka.conf.erb',
    modules          => $modules,
  }
}
