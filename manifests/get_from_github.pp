# private
define collectd::get_from_github(
  $localfolder = undef,
  $source      = undef,
  $ensure       = present,
  $revision    = 'master',
) {
  validate_string($source)

  unless $localfolder {
    $localfolder = $title
  }

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
