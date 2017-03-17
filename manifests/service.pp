# private
class collectd::service {
  service { 'collectd':
      ensure  => running,
      require => Package['collectd']
  }
}
