# Class: collectd
#
# This module installs collectd from SignalFx repositories
#
class collectd (
    $signalfx_api_token,
    $ensure_signalfx_collectd_version         = present,
    $signalfx_collectd_repo_source            = $collectd::params::signalfx_collectd_repo_source,
    $manage_service                           = $collectd::params::manage_service,
    # collectd.conf parameters
    $fqdnlookup                               = $collectd::params::fqdnlookup,
    $hostname                                 = $collectd::params::hostname,
    $interval                                 = $collectd::params::interval,
    $timeout                                  = $collectd::params::timeout,
    $read_threads                             = $collectd::params::read_threads,
    $write_queue_limit_high                   = $collectd::params::write_queue_limit_high,
    $write_queue_limit_low                    = $collectd::params::write_queue_limit_low,
    $collect_internal_stats                   = $collectd::params::collect_internal_stats,
    $log_file                                 = $collectd::params::log_file,
    $log_level                                = $collectd::params::log_level,
    $loadplugins                              = $collectd::params::loadplugins,
    $use_default_cpu_plugin                   = $collectd::params::use_default_cpu_plugin,
    $use_default_cpufreq_plugin               = $collectd::params::use_default_cpufreq_plugin,
    $use_default_df_plugin                    = $collectd::params::use_default_df_plugin,
    $use_default_disk_plugin                  = $collectd::params::use_default_disk_plugin,
    $use_default_interface_plugin             = $collectd::params::use_default_interface_plugin,
    $use_default_load_plugin                  = $collectd::params::use_default_load_plugin,
    $use_default_memory_plugin                = $collectd::params::use_default_memory_plugin,
    $use_default_protocols_plugin             = $collectd::params::use_default_protocols_plugin,
    $use_default_vmem_plugin                  = $collectd::params::use_default_vmem_plugin,
    $use_default_uptime_plugin                = $collectd::params::use_default_uptime_plugin,
    # write_http parameters
    $dimension_list                           = $collectd::params::dimension_list,
    $aws_integration                          = $collectd::params::aws_integration,
    $signalfx_api_endpoint                    = $collectd::params::signalfx_api_endpoint,
    $write_http_timeout                       = $collectd::params::write_http_timeout,
    $write_http_buffersize                    = $collectd::params::write_http_buffersize,
    $write_http_flush_interval                = $collectd::params::write_http_flush_interval,
    $write_http_log_http_error                = $collectd::params::write_http_log_http_error,
    # signalfx plugin parameters
    # dimension_list and aws_integration parameters are common to both write_http and signalfx plugins
    $ensure_signalfx_plugin_version           = $collectd::params::ensure_signalfx_plugin_version,
    $signalfx_plugin_repo_source              = $collectd::params::signalfx_plugin_repo_source,
    $signalfx_plugin_log_traces               = $collectd::params::signalfx_plugin_log_traces,
    $signalfx_plugin_interactive              = $collectd::params::signalfx_plugin_interactive,
    $signalfx_plugin_notifications            = $collectd::params::signalfx_plugin_notifications,
    $signalfx_plugin_notify_level             = $collectd::params::signalfx_plugin_notify_level,
    $signalfx_plugin_dpm                      = $collectd::params::signalfx_plugin_dpm,
    $signalfx_plugin_utilization              = $collectd::params::signalfx_plugin_utilization,
    $signalfx_plugin_cpu_utilization          = $collectd::params::signalfx_plugin_cpu_utilization,
    $signalfx_plugin_cpu_utilization_per_core = $collectd::params::signalfx_plugin_cpu_utilization_per_core,
    $filter_default_metrics                   = $collectd::params::filter_default_metrics,
    $filter_default_metric_rules              = $collectd::params::filter_default_metric_rules
)  inherits collectd::params {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  collectd::check_os_compatibility { $title:
  }
  -> anchor { 'collectd::begin': }
  -> class { '::collectd::get_signalfx_repository': }
  -> class { '::collectd::install': }
  -> class { '::collectd::config': }
  -> class { '::collectd::plugins::aggregation': }
  -> class { '::collectd::plugins::write_http': }
  -> class { '::collectd::plugins::signalfx': }
  -> anchor { 'collectd::end': }

  class { '::collectd::service': }
}
