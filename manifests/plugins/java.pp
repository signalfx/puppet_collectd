class collectd::plugins::java ( ) {
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/', '/usr/share/collectd/', '/usr/share/collectd/java-collectd-plugin/']:
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
    content => template('collectd/plugins/java/signalfx_types_db.erb'),
  }

  collectd::plugins::plugin_common { 'java':
    package_name         => 'collectd-java',
    plugin_file_name     => '10-jmx.conf',
    plugin_template_name => 'java/10-jmx.conf.erb',
  }
}
