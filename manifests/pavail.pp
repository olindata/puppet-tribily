class tribily::pavail {

  file { '/etc/zabbix/conf.d/pavail.conf':
    content => 'UserParameter=pavail,/usr/local/bin/pavail.sh',
  }


  file { '/usr/local/bin/pavail.sh':
    ensure => 'present',
    source => 'puppet:///tribily/pavail.sh',
    mode   => 755,
  }



}
