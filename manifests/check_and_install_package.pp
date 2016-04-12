# Checks if a package is defined and install otherwise
#
define collectd::check_and_install_package(
  $package_name = $title
) {
  if(!defined(Package[$package_name])){
    package { $package_name:
      ensure  => present,
      require => Class['collectd::get_signalfx_repository']
    }
  }
}