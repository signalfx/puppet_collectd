# Checks if a file exists and creates otherwise
#
define collectd::check_and_create_directory {
  if(!defined(File[$title])){
    file { $title:
      ensure => directory,
      mode   => '0750',
      owner  => 'root',
      group  => 'root',
    }
  }
}