class collectd::plugins::zookeeper (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/collectd/zookeeper-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get zk-collectd.py'],
  }

  file { 'get zk-collectd.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/zookeeper-collectd-plugin/zk-collectd.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/zookeeper/zk-collectd.py.erb'),
  }

  collectd::plugin { 'zookeeper':
    package_name        => 'collectd-python',
    config_file_name    => '20-zookeeper.conf',
    config_template     => 'collectd/plugins/zookeeper/20-zookeeper.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
