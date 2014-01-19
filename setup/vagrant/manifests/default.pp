Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }

File { owner => 0, group => 0, mode => 0644 }
file { '/etc/motd': content => "Food Inspections\n\n" }

class packages {
  exec { "pkgupdate":
    command => "apt-get update",
    user => "root",
    group => "root",
  }
  
  package { "vim":
    ensure => present,
	  require => Exec["pkgupdate"]
  }
  
  package { "build-essential":
    ensure => present,
	  require => Exec["pkgupdate"]
  }
  
  package { "curl":
	  ensure => present,
	  require => Exec["pkgupdate"]
  }
  
  package { "git":
	  ensure => present,
	  require => Exec["pkgupdate"]
  }
  
  package { "postgresql-9.1":
      ensure => present,
      require => Exec["pkgupdate"]
  }
  
  package { "postgresql-client-9.1":
      ensure => present,
      require => Exec["pkgupdate"]
  }
  
  package { "postgresql-server-dev-9.1":
	  ensure => present,
	  require => Exec["pkgupdate"]
  }
  
  package { "postgresql-9.1-postgis":
    ensure => present,
    require => Exec["pkgupdate"]
  }
}

node default {
  include packages
}
