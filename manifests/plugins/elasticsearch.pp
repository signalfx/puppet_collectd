class collectd::plugins::elasticsearch ( $modules ) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  file { ['/usr/share/', '/usr/share/collectd/', '/usr/share/collectd/elasticsearch-collectd-plugin/']:
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
    package_name         => 'collectd-python',
    plugin_file_name     => '20-elasticsearch.conf',
    plugin_template_name => 'elasticsearch/20-elasticsearch.conf.erb',
  }
}
