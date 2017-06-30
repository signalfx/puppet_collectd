# Configure the installed collectd package
#
class collectd::config inherits collectd {
  File {
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' {
    $log_file = 'stdout'
  }else {
    file { $collectd::log_file:
      ensure => present,
      before => File[$collectd::params::collectd_config_file]
    }
  }

  file { $collectd::params::plugin_config_dir_tree :
      ensure => directory
  }
  -> file { $collectd::params::collectd_config_file:
      content => template('collectd/collectd.conf.erb'),
      notify  => Service['collectd'],
  }
  -> file { $collectd::params::filtering_config_file:
      content => template('collectd/filtering.conf.erb'),
      notify  => Service['collectd'],
  }
  collectd::check_and_create_directory { '/usr/share/collectd/' : }
  -> collectd::check_and_create_directory { '/usr/share/collectd/java' : }
  -> collectd::check_and_create_directory { '/usr/share/collectd/python' : }
}
