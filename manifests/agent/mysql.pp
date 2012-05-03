class tribily::agent::mysql {

  tribily::agent::userparams{ 'mariadb':
    content       => template('mariadb/monitoring/tribily.conf'),
  }

  file { '/opt/tribily/bin/mysql_repl_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    mode    => 510,
    content => template('mariadb/monitoring/mysql_repl_status.pl.erb'),
  }

  file { '/opt/tribily/bin/mysql_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    mode    => 510,
    content => template('mariadb/monitoring/mysql_status.pl.erb'),

  }

  database_user{ "${tribily::params::monitor_mysql_user}@localhost":
    password_hash => $tribily::params::monitor_mysql_pass,
  }

  database_grant{ "${tribily::params::monitor_mysql_user}@localhost/*":
    privileges    => repl_client_priv
  }


}
