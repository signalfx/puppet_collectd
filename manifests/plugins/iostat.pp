class collectd::plugins::iostat (
  $modules,
  $db_template = 'collectd/plugins/iostat/iostat_types.db.erb',
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
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

  file { ['/usr/share/collectd/iostat-collectd-plugin/']:
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

  file { 'get iostat_types.db':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/iostat-collectd-plugin/iostat_types.db',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template($db_template),
  }

  collectd::plugin { 'iostat':
    package_name        => 'collectd-python',
    config_file_name    => '10-iostat.conf',
    config_template     => 'collectd/plugins/iostat/10-iostat.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
