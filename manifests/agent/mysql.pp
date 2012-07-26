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
    mode    => 550,
    content => template('tribily/mysql/mysql_repl_status.pl.erb'),
  }

  file { '/opt/tribily/bin/mysql_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    require => File['/opt/tribily/bin'],
    mode    => 550,
    content => template('tribily/mysql/mysql_status.pl.erb'),
  }

  package { 'libdbd-mysql-perl':
    ensure => latest
  }

  database_user{ "${tribily::params::monitor_mysql_user}@localhost":
    password_hash => mysql_password($tribily::params::monitor_mysql_pass),
    require       => Package['mysql-server']
  }

  # WH 20120722 this won't work until the mysql module implements global level
  # privileges
  database_grant{ "${tribily::params::monitor_mysql_user}@localhost":
    privileges    => [Repl_client_priv, Super_priv],
    require       => Package['mysql-server']
  }


}
