# Get signalfx repositories on the system
#
class collectd::get_signalfx_repository inherits collectd {
  if $collectd::use_signalfx_remote_repo {
    if $::osfamily == 'Debian' {
      # Be careful of dependencies here ( -> )
      if $::operatingsystem == 'Ubuntu' {
        include apt
        if(!defined(Package['apt-transport-https'])){
          package {'apt-transport-https': }
        }
        apt::key { 'SignalFx public key id for collectd':
          id => $collectd::params::signalfx_public_keyid,
        }
        -> apt::ppa { [$collectd::signalfx_collectd_repo_source, $collectd::signalfx_plugin_repo_source] :
          package_manage => true,
          require        => Package['apt-transport-https']
        }
      } else {
        # apt module does not support wheezy and jessie
        exec { "Add ${collectd::signalfx_collectd_repo_source}, ${collectd::signalfx_plugin_repo_source}":
          command => "apt-get update &&
                          apt-get install -y apt-transport-https &&
                          apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${collectd::params::signalfx_public_keyid} &&
                          mkdir -p /etc/apt/sources.list.d/ &&
                          echo ${collectd::signalfx_collectd_repo_source} > /etc/apt/sources.list.d/signalfx-collectd.list &&
                          echo ${collectd::signalfx_plugin_repo_source} > /etc/apt/sources.list.d/signalfx-plugin.list &&
                          apt-get update",
          unless  => 'test -s /etc/apt/sources.list.d/signalfx-collectd.list && test -s /etc/apt/sources.list.d/signalfx-plugin.list'
        }
      }
    }
    if $::osfamily == 'Redhat' {
      if $collectd::params::old_signalfx_collectd_repo_source != undef {
        package { $collectd::params::old_signalfx_collectd_repo_source:
          ensure => absent
        }
      }
      exec { "Add ${collectd::signalfx_collectd_repo_source}, ${collectd::signalfx_plugin_repo_source}":
        command => "yum install -y ${collectd::params::signalfx_collectd_repo_source} ${collectd::params::signalfx_plugin_repo_source}",
        unless  => "test -s ${collectd::params::signalfx_collectd_repo_filename} && test -s ${collectd::params::signalfx_plugin_repo_filename}"
      }
    }
  }
}
