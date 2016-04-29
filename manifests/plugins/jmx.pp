# jmx plugin
#
class collectd::plugins::jmx {
 
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
 
  $typesdbfile = "${collectd::params::plugin_config_dir}/signalfx_types_db"
 
  file { 'Add signalfx typesdb':
    ensure  => present,
    path    => $typesdbfile,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('collectd/plugins/signalfx_types_db.erb'),
    require => Class['collectd::config']
  } ->
  file_line { 'Ensure collectd typesdb':
    ensure  => present,
    line    => "TypesDB \"/usr/share/collectd/types.db\"",
    path    => $collectd::params::collectd_config_file,
    notify  => Class['service'],
    require => Class['collectd::config']
  } ->
  collectd::plugins::plugin_common { 'jmx':
    package_name         => 'collectd-java',
    plugin_file_name     => '10-jmx.conf',
    plugin_template_name => 'jmx.conf.erb'
  }
}