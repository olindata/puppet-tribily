class tribily::pavail {

  file { '/etc/zabbix/conf.d/pavail.conf':
    content => 'UserParameter=vm.memory.size[*],/usr/local/bin/pavail.sh',
  }


  file { '/usr/local/bin/pavail.sh':
    ensure => 'present',
    source => 'puppet:///tribily/pavail.sh',
    mode   => 755,
  }



}
