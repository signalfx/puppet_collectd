# elasticsearch plugin
#
class collectd::plugins::elasticsearch (
    $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  collectd::get_from_github { $title:
    localfolder => '/usr/share/collectd/python/collectd-elasticsearch',
    source      => 'https://github.com/signalfx/collectd-elasticsearch'
  } ->
  collectd::plugins::plugin_common { 'elasticsearch':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-elasticsearch.conf',
    plugin_template_name => 'elasticsearch.conf.erb'
  }
}
