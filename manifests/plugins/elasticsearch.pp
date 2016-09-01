class collectd::plugins::elasticsearch (
  $modules,
  $filter_metrics = false,
  $filter_metric_rules = {},
) {
  validate_hash($modules)
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

  collectd::plugin { 'elasticsearch':
    package_name        => 'collectd-python',
    config_file_name    => '20-elasticsearch.conf',
    config_template     => 'collectd/plugins/elasticsearch/20-elasticsearch.conf.erb',
    modules             => $modules,
    filter_metrics      => $filter_metrics,
    filter_metric_rules => $filter_metric_rules,
  }
}
