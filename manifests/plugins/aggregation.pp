# private
class collectd::plugins::aggregation {
  include collectd

  collectd::plugins::plugin_common { 'aggregation':
    plugin_file_name     => '10-aggregation-cpu.conf',
    plugin_template_name => '../aggregation-cpu.conf.erb'
  }
}
