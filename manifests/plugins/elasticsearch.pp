class collectd::plugins::elasticsearch (
  Hash $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
  $plugin_template = 'collectd/plugins/elasticsearch/20-elasticsearch.conf.erb',
  $package_name = 'collectd-python',
  $package_ensure = present,
  $package_required = false
) {
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/collectd/elasticsearch-collectd-plugin/']:
    ensure => directory,
    owner  => root,
    group  => 'root',
    mode   => '0755',
    before => File['get elasticsearch_collectd.py'],
  }

  file { 'get elasticsearch_collectd.py':
    ensure  => present,
    replace => 'yes',
    path    => '/usr/share/collectd/elasticsearch-collectd-plugin/elasticsearch_collectd.py',
    owner   => root,
    group   => 'root',
    mode    => '0755',
    content => template('collectd/plugins/elasticsearch/elasticsearch_collectd.py.erb'),
  }

  collectd::plugins::plugin_common { 'elasticsearch':
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
    package_name        => $package_name,
    package_ensure      => $package_ensure,
    package_required    => $package_required,
    plugin_file_name    => '20-elasticsearch.conf',
    plugin_template     => $plugin_template,
  }
}
