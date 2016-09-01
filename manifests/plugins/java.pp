class collectd::plugins::java (
  $modules,
  $db_template = 'collectd/plugins/java/signalfx_types_db.erb',
) {
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/collectd/java-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get signalfx_types_db'],
  }

  file { 'get signalfx_types_db':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/java-collectd-plugin/signalfx_types_db',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template($db_template),
  }

  collectd::plugin { 'java':
    package_name     => 'collectd-java',
    config_file_name => '10-jmx.conf',
    config_template  => 'collectd/plugins/java/10-jmx.conf.erb',
    modules          => $modules,
  }
}
