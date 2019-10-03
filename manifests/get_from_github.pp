define collectd::get_from_github (
  Optional[String] $localfolder = undef,
  Optional[String] $source      = undef,
  $ensure                       = present,
  String $revision              = 'master',
) {
  unless(defined(Package['git'])) {
    package { 'git':
      ensure => present,
    }
  }

  unless(defined(Vcsrepo[$localfolder])) {
    vcsrepo { $localfolder:
      ensure   => $ensure,
      provider => git,
      source   => $source,
      revision => $revision,
      require  => Package['git'],
    }
  }
}
