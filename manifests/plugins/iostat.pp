class collectd::plugins::iostat (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/iostat/10-iostat.conf.erb',
  $package_name = 'collectd-iostat',
  $package_ensure = present,
  $package_required = false
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  unless $package_required {
    if $::osfamily == 'RedHat' {
      exec { 'install epel-release':
        command => 'yum install -y epel-release',
        before  => Package['sysstat']
      }
    }

    unless(defined(Package['sysstat'])) {
      package { 'sysstat':
        ensure => present,
      }
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
  }

  collectd::plugins::plugin_common { 'iostat':
    package_name     => $package_name,
    package_ensure   => $package_ensure,
    package_required => $package_required,
    plugin_file_name => '10-iostat.conf',
    plugin_template  => $plugin_template,
  }
}
