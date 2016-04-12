# private
define collectd::get_from_github(
  $localfolder,
  $source
) {
  if(!defined(Vcsrepo[$localfolder])){
    check_and_install_package { $title:
      package_name => 'git'
    } ->
    vcsrepo { $localfolder:
      ensure   => present,
      provider => git,
      source   => $source,
      require  => Package['git']
    }
  }
}
