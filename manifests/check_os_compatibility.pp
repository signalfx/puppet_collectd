# Check if the os is compatible
#
define collectd::check_os_compatibility {
  if $::osfamily != 'Debian' and $::osfamily != 'Redhat' {
    fail("Your osfamily : ${::osfamily} is not supported.")
  }
  if $::operatingsystem != 'Debian' and $::operatingsystem != 'Ubuntu' and
      $::operatingsystem != 'CentOS' and $::operatingsystem != 'Amazon' and
        $::operatingsystem != 'RedHat' {
    fail("Your operating system : ${::operatingsystem} is not supported.")
  }
  if versioncmp($::facterversion, '1.6.18') <= 0 and
      $::operatingsystem == 'Amazon' {
    fail("Your facter version ${::facterversion} is not supported by our
          module. more info can be found at
          https://support.signalfx.com/hc/en-us/articles/205675369")
  }
}
