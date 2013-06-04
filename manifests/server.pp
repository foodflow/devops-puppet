class { 'apache': }

apache::vhost { "${fqdn}":
  port    => '80',
  docroot => "${fqdn}"
}

class { 'apt':
  always_apt_update    => false,
  disable_keys         => false,
  purge_sources_list   => false,
  purge_sources_list_d => false,
  purge_preferences_d  => false
}

apt::source { 'ubuntugis':
  location   => 'http://ppa.launchpad.net/ubuntugis',
  repos      => 'main',
  key        => '314DF160',
  key_server => 'keyserver.ubuntu.com',
}

package { 'postgresql-9.1-postgis'
  ensure => present
}

package { 'postgresql-contrib-9.1'
  ensure => present
}


