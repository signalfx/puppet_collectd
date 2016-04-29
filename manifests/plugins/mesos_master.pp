# mesos_master plugin
#
class collectd::plugins::mesos_master (
    $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  collectd::get_from_github { $title:
    localfolder => '/opt/collectd-mesos',
    source      => 'https://github.com/signalfx/collectd-mesos'
  } ->
  collectd::plugins::plugin_common { 'mesos':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-mesos.conf',
    plugin_template_name => 'mesos_master.conf.erb'
  }
}
