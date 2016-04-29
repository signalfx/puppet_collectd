# docker plugin
#
class collectd::plugins::docker (
    $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  collectd::get_from_github { $title:
    localfolder => '/usr/share/collectd/python/docker-collectd-plugin',
    source      => 'https://github.com/signalfx/docker-collectd-plugin.git'
  } ->
  collectd::plugins::plugin_common { 'docker':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-docker.conf',
    plugin_template_name => 'docker.conf.erb'
  }
}
