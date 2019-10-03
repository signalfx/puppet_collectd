class collectd::plugins::haproxy (
  Hash $modules,
  $version,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/haproxy/haproxy.conf.erb',
  $package_name = 'collectd-python',
  $package_ensure = present,
  $package_required = false
) {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::get_from_github { $title:
    localfolder => '/usr/share/collectd/collectd-haproxy',
    source      => 'https://github.com/signalfx/collectd-haproxy',
    revision    =>  $version
  }
  -> collectd::plugins::plugin_common { 'haproxy':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '10-haproxy.conf',
    plugin_template     => $plugin_template,
  }
}
