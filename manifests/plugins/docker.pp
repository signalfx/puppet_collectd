class collectd::plugins::docker (
  $modules,
  $db_template = 'collectd/plugins/docker/dockerplugin.db.erb',
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  if $::osfamily == 'RedHat' {
    exec { 'install epel-release':
      command => 'yum install -y epel-release',
      before  => Package['python-pip']
    }
  }

  package { 'python-pip':
    ensure => present,
  }

  exec { 'install docker dependencies':
    command => 'pip install py-dateutil && pip install docker-py>=1.0.0 && pip install jsonpath_rw',
    require => Package['python-pip']
  }

  file { ['/usr/share/collectd/docker-collectd-plugin/']:
    ensure  => directory,
    owner   => root,
    group   => 'root',
    mode    => '0755',
    before  => File['get dockerplugin.py'],
    require => Exec['install docker dependencies']
  }

  file { 'get dockerplugin.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/docker-collectd-plugin/dockerplugin.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/docker/dockerplugin.py.erb'),
    before  => File['get dockerplugin.db'],
  }

  file { 'get dockerplugin.db':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/docker-collectd-plugin/dockerplugin.db',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/docker/dockerplugin.db.erb'),
  }

  collectd::plugin { 'docker':
    package_name     => 'collectd-python',
    config_file_name => '10-docker.conf',
    config_template  => 'collectd/plugins/docker/10-docker.conf.erb',
    modules          => $modules,
  }
}
