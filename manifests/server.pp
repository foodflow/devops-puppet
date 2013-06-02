class { 'apache': }

apache::vhost { "${hostname}":
  port    => '80',
  docroot => "${hostname}"
}

