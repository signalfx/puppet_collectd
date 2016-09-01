class collectd::plugins::aggregation {
  include collectd

  collectd::plugin { 'aggregation':
    manage_package   => false,
    config_file_name => '10-aggregation-cpu.conf',
    config_template  => 'collectd/aggregation-cpu.conf.erb'
  }
}
