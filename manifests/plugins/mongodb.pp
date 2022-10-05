class collectd::plugins::mongodb (
  Hash $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/mongodb/10-mongodb.conf.erb',
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

  exec { 'install mongodb dependencies':
    command => 'pip install pymongo==3.0.3',
    require => Package['python-pip']
  }

  file { ['/usr/share/collectd/mongodb-collectd-plugin/']:
    ensure  => directory,
    owner   => root,
    group   => 'root',
    mode    => '0755',
    before  => File['get mongodb.py'],
    require => Exec['install mongodb dependencies']
  }

  file { 'get mongodb.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/mongodb-collectd-plugin/mongodb.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/mongodb/mongodb.py.erb'),
  }

  collectd::plugins::plugin_common { 'mongodb':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '10-mongodb.conf',
    plugin_template     => $plugin_template,
  }
}
