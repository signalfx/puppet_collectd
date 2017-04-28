# private
class collectd::service {
  if $collectd::manage_service {
    service { 'collectd':
        ensure  => running,
        require => Package['collectd']
    }
  }
}
