class collectd::plugins::kafka (
  Hash $modules,
  $plugin_template = 'collectd/plugins/kafka/20-kafka.conf.erb',
  $package_name = 'UNSET',
  $package_ensure = present,
  $package_required = false
) {
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  include collectd::plugins::java

  collectd::plugins::plugin_common { 'kafka':
    modules          => $modules,
    package_name     => $package_name,
    package_ensure   => $package_ensure,
    package_required => $package_required,
    plugin_file_name => '20-kafka.conf',
    plugin_template  => $plugin_template,
  }
}
