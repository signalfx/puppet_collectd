# rabbitmq plugin
#
class collectd::plugins::rabbitmq (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/rabbitmq/rabbitmq.conf.erb',
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::get_from_github { $title:
    localfolder => '/opt/collectd-rabbitmq',
    source      => 'https://github.com/signalfx/collectd-rabbitmq'
  } ->
  collectd::plugins::plugin_common { 'rabbitmq':
    package_name     => 'collectd-python',
    plugin_file_name => '10-rabbitmq.conf',
    plugin_template  => $plugin_template,
  }
}
