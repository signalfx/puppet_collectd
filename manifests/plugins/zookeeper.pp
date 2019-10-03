class collectd::plugins::zookeeper (
  Hash $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/zookeeper/20-zookeeper.conf.erb',
  $package_name = 'collectd-python',
  $package_ensure = present,
  $package_required = false
) {
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

  collectd::plugins::plugin_common { 'zookeeper':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '20-zookeeper.conf',
    plugin_template     => $plugin_template,
  }
}
