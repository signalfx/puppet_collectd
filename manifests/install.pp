# Install collectd, signalfx-collectd-plugin and other important packages
#
class collectd::install inherits collectd {
    if $::osfamily == 'Debian' {
      package { ['collectd-core', 'collectd']:
          ensure  => $collectd::ensure_signalfx_collectd_version,
      }
    }
    if $::osfamily == 'Redhat' {
      package { ['collectd', 'collectd-disk']:
        ensure          => $collectd::ensure_signalfx_collectd_version,
        provider        => 'yum',
        install_options => {
          '--disablerepo' => 'epel*',
          '--enablerepo'  => 'SignalFx-collectd',
        },
      }
    }
}
