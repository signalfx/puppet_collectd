# mongodb plugin
#
class collectd::plugins::mongodb (
    $modules,
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  if $::osfamily == 'RedHat' {
    exec {'install epel-release':
      command => 'yum install -y epel-release',
      before  => Package['python-pip']
    }
  }
  
  collectd::check_and_install_package { "${title}::python-pip":
    package_name => 'python-pip'
  }
  
  exec {'install mongodb py':
    command => 'pip install pymongo==3.0.3',
    require => Package['python-pip']
  }
  
  collectd::get_from_github { $title:
    localfolder => '/opt/collectd-mongodb',
    source      => 'https://github.com/signalfx/collectd-mongodb'
  } ->
  collectd::plugins::plugin_common { 'mongodb':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-mongodb.conf',
    plugin_template_name => 'mongodb.conf.erb'
  }
}
