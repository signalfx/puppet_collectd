class collectd::plugins::iostat ( $modules ) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  if $::osfamily == 'RedHat' {
    exec { 'install epel-release':
      command => 'yum install -y epel-release',
      before  => Package['sysstat']
    }
  }

  package { 'sysstat':
    ensure => present,
  }

  file { ['/usr/share/', '/usr/share/collectd/', '/usr/share/collectd/iostat-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get collectd_iostat_python.py']
  }

  file { 'get collectd_iostat_python.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/iostat-collectd-plugin/collectd_iostat_python.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/iostat/collectd_iostat_python.py.erb'),
    require => Package['sysstat']
  }

  collectd::plugins::plugin_common { 'iostat':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-iostat.conf',
    plugin_template_name => 'iostat/10-iostat.conf.erb',
  }
}
