class collectd::plugins::docker (
  Hash $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/docker/10-docker.conf.erb',
  $package_name = 'collectd-python',
  $package_ensure = present,
  $package_required = false
) {
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

  collectd::plugins::plugin_common { 'docker':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '10-docker.conf',
    plugin_template     => $plugin_template,
  }
}
