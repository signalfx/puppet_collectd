class collectd::plugins::vmstat (
  $modules,
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

  file { ['/usr/share/collectd/vmstat-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get vmstat_collectd.py']
  }

  file { 'get vmstat_collectd.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/vmstat-collectd-plugin/vmstat_collectd.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/vmstat/vmstat_collectd.py.erb'),
    require => Package['sysstat']
  }

  collectd::plugin { 'vmstat':
    package_name        => 'collectd-python',
    config_file_name    => '10-vmstat.conf',
    config_template     => 'collectd/plugins/vmstat/10-vmstat.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
