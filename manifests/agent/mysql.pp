class tribily::agent::mysql {

  tribily::agent::userparams{ 'mariadb':
    content       => template('tribily/mysql/tribily.conf'),
  }

  file { '/opt/tribily/bin/mysql_repl_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    mode    => 510,
    content => template('tribily/mysql/mysql_repl_status.pl.erb'),
  }

  file { '/opt/tribily/bin/mysql_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    mode    => 510,
    content => template('tribily/mysql/mysql_status.pl.erb'),

  }

#TODO: implement properly when stored configs and exported resources are working
#  @@database_user{ "${tribily::params::monitor_mysql_user}@localhost":
#    password_hash => $tribily::params::monitor_mysql_pass,
#  }
#
#  @@database_grant{ "${tribily::params::monitor_mysql_user}@localhost/*":
#    privileges    => repl_client_priv
#  }


}
