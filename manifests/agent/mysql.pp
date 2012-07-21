class tribily::agent::mysql {

  $monitor_user = $::tribily::params::monitor_mysql_user
  $monitor_pass = $::tribily::params::monitor_mysql_pass

  tribily::agent::userparams{ 'mariadb':
    content       => template('tribily/mysql/mysql_userparams.conf.erb'),
  }

  file { '/opt/tribily/bin/mysql_repl_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    require => File['/opt/tribily/bin'],
    mode    => 510,
    content => template('tribily/mysql/mysql_repl_status.pl.erb'),
  }

  file { '/opt/tribily/bin/mysql_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    require => File['/opt/tribily/bin'],
    mode    => 510,
    content => template('tribily/mysql/mysql_status.pl.erb'),
  }

  package { 'libdbd-mysql-perl':
    ensure => latest
  }

  database_user{ "${tribily::params::monitor_mysql_user}@localhost":
    password_hash => mysql_password($tribily::params::monitor_mysql_pass),
    require       => Package['mysql-server']
  }

  database_grant{ "${tribily::params::monitor_mysql_user}@localhost/*":
    privileges    => [repl_client_priv, super_priv],
    require       => Package['mysql-server']
  }


}
