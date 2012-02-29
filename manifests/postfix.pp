
# for tribily monitoring
#  http://tribily.com/doc/monitor-your-postfix-servers-using-tribily-monitoring-systems

class tribily::postfix {

  case $operatingsystem {
    debian, ubuntu: {
      $maillog = '/var/log/mail.log'
    }
    centos, redhat, oel, linux: {
      $maillog = '/var/log/maillog'
    }
    default: {
      # wag
      $maillog = '/var/log/mail.log'
    }
  }


  package { 'pflogsumm':
    ensure => 'present'
  }

  package { 'logtail':
    ensure => 'present'
  }
  
  file { '/etc/zabbix/conf.d/postfix.conf':
    content => "UserParameter=pfmailq,mailq | grep -v 'Mail queue is empty' | grep -c '^[0-9A-Z]'",
  }
  
  file { '/usr/local/bin/postfix_status.sh':
    content =>  template('tribily/postfix_status.sh'),
    mode => '755',
  }
  
  cron { 'tribily postfix status':
    command => '/usr/local/bin/postfix_status.sh > /dev/null 2>&1',
    minute => '*/5',
  }


}
