class { 'apache': }

apache::mod { 'rewrite': }

file{ '/var/www/vhosts':
  ensure => directory
}

apache::vhost { "${fqdn}":
  port    => '80',
  docroot => "/var/www/vhosts/${fqdn}"
}

class { 'apt':
  always_apt_update    => false,
  disable_keys         => false,
  purge_sources_list   => false,
  purge_sources_list_d => false,
  purge_preferences_d  => false
}

$postgres = [ 'postgresql-9.1-postgis', 'postgresql-contrib-9.1' ]

apt::ppa { 'ppa:ubuntugis/ubuntugis-unstable': }
->package { $postgres : ensure => present }

->class {'postgresql::server':
  config_hash => {
    'ip_mask_deny_postgres_user' => '0.0.0.0/32',
    'postgres_password' => 'g!sfl0ws',
    'ipv4acls'          => ['host all ffgis 127.0.0.1/32 md5']
  }
}

->postgresql::db{ 'foodflow_gis':
  user     => 'ffgis',
  password => 'foodflow'
}

apt::ppa { 'ppa:voronov84/andreyv': }
->package { 'pgadmin3': ensure => present }

$tilemill = [ 'tilemill', 'libmapnik', 'nodejs' ]

apt::ppa { 'ppa:developmentseed/mapbox': }
->package { $tilemill : ensure => present }

->apache::vhost { "tile.${fqdn}":
  port     => '80',
  docroot  => "/usr/share/mapbox/export",
  options  => 'FollowSymLinks',
  override => [ 'FileInfo', 'Options' ]
}

include php
include php::apache2

php::module { 'pgsql': notify => Service['apache2'], }

package { 'phppgadmin': ensure => present }

