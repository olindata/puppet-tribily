

class tribily::debian {

  case $operatingsystem {
    debian, ubuntu: {
    }
    default: {
      error("can't monitor non-debian systems")
    }
  }

  file { '/etc/zabbix/conf.d/debian.conf':
    content => 'UserParameter=debian_updates[*],/usr/local/bin/debian_status.sh $1',
  }

  # untested on debian
  file { '/usr/local/bin/debian_status.sh':
    content => "#!/bin/sh
r=${::lsbdistrelease}
apt-get update 2>&1 > /dev/null
if [ \"x\$1\" = \"xsecurity\" ] ; then
  v=''
else
  v='!'
fi
aptitude search \"~U \$v(~Astable \${r%.*})\" | wc -l
"  ,
    mode => '755',
  }

 

}

