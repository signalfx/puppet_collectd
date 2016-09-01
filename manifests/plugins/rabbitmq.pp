class collectd::plugins::rabbitmq (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::get_from_github { $title:
    localfolder => '/opt/collectd-rabbitmq',
    source      => 'https://github.com/signalfx/collectd-rabbitmq'
  } ->
  collectd::plugin { 'rabbitmq':
    package_name        => 'collectd-rabbitmq',
    config_file_name    => '10-rabbitmq.conf',
    config_template     => 'collectd/plugins/rabbitmq/rabbitmq.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
