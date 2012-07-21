class tribily::agent::postfix(
  $maillog        = '/var/log/maillog',
  $zabbixconf     = '/etc/zabbix/zabbix_agentd.conf',
  $pflogsumm      = '/usr/local/sbin/pflogsumm.pl',
  $logtail        = '/usr/sbin/logtail',
  $zabbixsender   = '/usr/local/bin/zabbix_sender',
  $zabbixagentlog = '/var/log/zabbix-agent'
) {

  package { 'logtail':
    ensure => installed
  }
  package { 'pflogsumm':
    ensure => installed
  }

  tribily::agent::userparams{ 'postfix':
    content       => template('tribily/postfix/postfix_userparams.conf.erb'),
  }

  file { '/opt/tribily/bin/postfix_status.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    require => [
      File['/opt/tribily/bin'],
      Package['zabbix-agent'],
      Package['postfix'],
      Package['logtail'],
      Package['pflogsumm']
    ],
    mode    => 550,
    content => template('tribily/postfix/postfix_status.sh.erb'),
  }

  cron { 'tribily postfix status':
    ensure  => present,
    command => 'sh /opt/tribily/bin/postfix_status.sh',
    minute  => '*/5',
    require => File['/opt/tribily/bin/postfix_status.sh']
  }

}