# rabbitmq plugin
#
class collectd::plugins::rabbitmq (
  $modules
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::get_from_github { $title:
    localfolder => '/opt/collectd-rabbitmq',
    source      => 'https://github.com/signalfx/collectd-rabbitmq'
  } ->
  collectd::plugins::plugin_common { 'rabbitmq':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-rabbitmq.conf',
    plugin_template_name => 'rabbitmq/rabbitmq.conf.erb'
  }
}
