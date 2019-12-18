# Checks if a package is defined and install otherwise
#
define collectd::check_and_install_package(
  $package_name = $title,
  $package_ensure = present,
) {
  if(!defined(Package[$package_name])){
    if $::osfamily == 'Debian' {
      package { $package_name:
        ensure  => $package_ensure,
        require => Class['collectd::get_signalfx_repository']
      }
    }

    if $::osfamily == 'Redhat' {
      package { $package_name:
        ensure          => $package_ensure,
        provider        => 'yum',
        require         => Class['collectd::get_signalfx_repository'],
        install_options => {
          '--disablerepo' => 'epel*',
          '--enablerepo'  => 'SignalFx-collectd',
        }
      }
    }
  }
}
