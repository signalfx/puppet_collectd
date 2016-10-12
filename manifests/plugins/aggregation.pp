# private
class collectd::plugins::aggregation(
  $plugin_template = 'collectd/aggregation-cpu.conf.erb'
) {
  include collectd

  collectd::plugins::plugin_common { 'aggregation':
    package_name     => 'UNSET',
    package_ensure   => present,
    package_required => false,
    plugin_file_name => '10-aggregation-cpu.conf',
    plugin_template  => $plugin_template,
  }
}
