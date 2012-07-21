class tribily::agent::postfix(
  $maillog        = '/var/log/maillog',
  $zabbixconf     = '/etc/zabbix/zabbix_agentd.conf',
  $pflogsumm      = '/usr/local/sbin/pflogsumm.pl',
  $logtail        = '/usr/sbin/logtail',
  $zabbixsender   = '/usr/local/bin/zabbix_sender',
  $zabbixagentlog = '/var/log/zabbix-agent'
) {

  case $::lsbdistcodename {
    'lenny': {
      $pflogsumm_params = '--no_bounce_detail --no_deferral_detail --no_reject_detail --no_smtpd_warnings '
    }
    'squeeze': {
      $pflogsumm_params = 'bounce_detail=0 deferral_detail=0 reject_detail=0 smtpd_warning_detail=0 '
    }
    default: {
      err "tribily::agent::postfix is not implemented for  ${::lsbdistcodename}"
    }
  }

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