# signalfx plugin
class collectd::plugins::signalfx(
  $ensure_signalfx_plugin_version           = $collectd::ensure_signalfx_plugin_version,
  $signalfx_plugin_repo_source              = $collectd::signalfx_plugin_repo_source,
  $dimension_list                           = $collectd::dimension_list,
  $aws_integration                          = $collectd::aws_integration,
  $signalfx_api_endpoint                    = $collectd::signalfx_api_endpoint,
  $signalfx_plugin_log_traces               = $collectd::signalfx_plugin_log_traces,
  $signalfx_plugin_interactive              = $collectd::signalfx_plugin_interactive,
  $signalfx_plugin_notifications            = $collectd::signalfx_plugin_notifications,
  $signalfx_plugin_notify_level             = $collectd::signalfx_plugin_notify_level,
  $signalfx_plugin_dpm                      = $collectd::signalfx_plugin_dpm,
  $signalfx_plugin_utilization              = $collectd::signalfx_plugin_utilization,
  $signalfx_plugin_cpu_utilization          = $collectd::signalfx_plugin_cpu_utilization,
  $signalfx_plugin_cpu_utilization_per_core = $collectd::signalfx_plugin_cpu_utilization_per_core
) inherits collectd {

  $dimensions = get_dimensions($dimension_list, $aws_integration)
  $signalfx_api_endpoint_with_dimensions = "${signalfx_api_endpoint}${dimensions}"
  notify {"Collectd will transmit metrics to this url: ${signalfx_api_endpoint_with_dimensions}":}

  collectd::check_and_install_package { 'signalfx-collectd-plugin':
    before  => File['load Signalfx plugin']
  }
  if $::osfamily == 'Redhat' {
    collectd::check_and_install_package { $title:
      package_name => 'collectd-python',
      before       => File['load Signalfx plugin']
    }
  }

  file { 'load Signalfx plugin':
    ensure  => present,
    path    => "${collectd::params::plugin_config_dir}/10-signalfx.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('collectd/signalfx_plugin.conf.erb'),
    notify  => Class['collectd::service']
  }
}
