# zookeeper plugin
#
class collectd::plugins::zookeeper (
    $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  collectd::get_from_github { $title:
    localfolder => '/opt/zookeeper-collectd-plugin',
    source      => 'https://github.com/signalfx/collectd-zookeeper'
  } ->
  collectd::plugins::plugin_common { 'zookeeper':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-zookeeper.conf',
    plugin_template_name => 'zookeeper.conf.erb'
  }
}
