class { 'apache': }

apache::vhost { "${fqdn}":
  port    => '80',
  docroot => "${fqdn}"
}

