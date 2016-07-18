class collectd::plugins::mesos ( $modules ) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/', '/usr/share/collectd/', '/usr/share/collectd/mesos-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get mesos-master.py'],
  }

  file { 'get mesos-master.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/mesos-collectd-plugin/mesos-master.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/mesos/mesos-master.py.erb'),
    before  => File['get mesos_collectd.py'],
  }

  file { 'get mesos_collectd.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/mesos-collectd-plugin/mesos_collectd.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/mesos/mesos_collectd.py.erb'),
  }

  collectd::plugins::plugin_common { 'mesos':
    plugin_file_name     => '10-mesos-master.conf',
    plugin_template_name => 'mesos/10-mesos-master.conf.erb',
  }
}
