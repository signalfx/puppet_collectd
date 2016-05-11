# redis master plugin
#
class collectd::plugins::redis (
  $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  collectd::get_from_github { $title:
    localfolder => '/opt/redis-collectd-plugin',
    source      => 'https://github.com/signalfx/redis-collectd-plugin'
  } ->
  collectd::plugins::plugin_common { 'redis':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-redis.conf',
    plugin_template_name => 'redis.conf.erb'
  }
}
