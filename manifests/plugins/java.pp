class collectd::plugins::java (
  $plugin_template = 'collectd/plugins/java/10-jmx.conf.erb',
  $package_name = 'collectd-java',
  $package_ensure = present,
  $package_required = ($::osfamily == 'RedHat')
) {
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  unless $package_required {
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
      content => template('collectd/plugins/java/signalfx_types_db.erb'),
    }
  }

  collectd::plugins::plugin_common { 'java':
    package_name     => $package_name,
    package_ensure   => $package_ensure,
    package_required => $package_required,
    plugin_file_name => '10-jmx.conf',
    plugin_template  => $plugin_template,
  }
}
