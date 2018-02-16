# common code for the 3rd party plugins
#
define collectd::plugins::plugin_common (
  $plugin_file_name,
  $plugin_template,
  $modules = undef,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $package_name = 'UNSET',
  $package_ensure = present,
  $package_required = false,
){
  validate_string($plugin_file_name)
  validate_string($plugin_template)

  if $package_name != 'UNSET' and $package_required == true {
    collectd::check_and_install_package { "${package_name} for ${plugin_file_name}":
      package_name   => $package_name,
      package_ensure => $package_ensure,
      before         => File["load ${plugin_file_name} plugin"]
    }
  }

  file { "load ${plugin_file_name} plugin":
    ensure  => present,
    path    => "${collectd::params::plugin_config_dir}/${plugin_file_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template($plugin_template),
    notify  => Service['collectd'],
    require => Class['collectd::config']
  }
}
