class collectd::plugins::write_http(
  $dimension_list                    = $collectd::dimension_list,
  $aws_integration                   = $collectd::aws_integration,
  $signalfx_api_endpoint             = $collectd::signalfx_api_endpoint,
  $write_http_timeout                = $collectd::write_http_timeout,
  $write_http_buffersize             = $collectd::write_http_buffersize,
  $write_http_flush_interval         = $collectd::write_http_flush_interval,
  $write_http_log_http_error         = $collectd::write_http_log_http_error,
) inherits collectd {

  $dimensions = get_dimensions($dimension_list, $aws_integration)
  $signalfx_api_endpoint_with_dimensions = "${signalfx_api_endpoint}${dimensions}"

  if $::osfamily == 'Redhat' {
    collectd::check_and_install_package { $title :
      package_name => 'collectd-write_http',
      before       => File['load write_http plugin']
    }
  }

  file { 'load write_http plugin':
    ensure  => present,
    path    => "${collectd::params::plugin_config_dir}/10-write_http.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('collectd/write_http.conf.erb'),
    notify  => Class['collectd::service']
  }
}
