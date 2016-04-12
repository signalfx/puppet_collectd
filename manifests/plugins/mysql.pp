# mysql plugin
#
class collectd::plugins::mysql (
  $databases,
)  {
  validate_hash($databases)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd

  collectd::plugins::plugin_common { 'mysql':
    package_name         => 'collectd-mysql',
    plugin_file_name     => '10-mysql.conf',
    plugin_template_name => 'mysql/mysql.conf.erb'
  }
}
