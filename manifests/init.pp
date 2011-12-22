# Class: puppet-tribily
#
# This module manages puppet-tribily
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class tribily {
  
  include tribily::params
  
  # the version in Debian Lenny is 1.4.7, which is too old and buggy
  if $::lsbdistcodename == 'lenny' {
    include apt::repo::lenny-backports
  }
  
  # install zabbix agent.  This requires that the zabbix package 
  package { "zabbix-agent": 
    ensure    => "present",
  }

  user { "zabbix": 
    ensure    => "present",
  }

  # install the zabbix_agent.conf file
  file { "/etc/zabbix/zabbix_agent.conf":
    ensure  => present,
    mode    => 0644, 
    owner   => 'root', 
    group   => 'root',
    content => template("tribily/zabbix_agent.conf.erb"),
    require => Package["zabbix-agent"],
  }
  
  # install the zabbix_agentd.conf file
  file { "/etc/zabbix/zabbix_agentd.conf":
    ensure  => present,
    mode    => 0644, 
    owner   => 'root', 
    group   => 'root',
    content => template("tribily/zabbix_agentd.conf.erb"),
    require => Package["zabbix-agent"],
  }

  file { "/var/run/zabbix-agent":
    ensure  => directory,
    mode    => 0644,
    owner   => zabbix,
    group   => zabbix,    
    require => User["zabbix"],
  }
  
  file { "/var/log/zabbix-agent":
    ensure  => directory,
    mode    => 0644,
    owner   => zabbix,
    group   => zabbix,    
  }

  # Ensure the correct puppet.conf file is installed
  file { "/etc/init.d/zabbix-agent":
    ensure  => present,
    mode    => 0755,
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/tribily/zabbix-agent-init",
    require => Package["zabbix-agent"]
  }

  # ensure that the zabbix-agent is running
  service { "zabbix-agent":
    ensure      => running,
    enable      => true,
    status      => "/etc/init.d/zabbix-agent status",
    hasrestart  => true,
    hasstatus   => false,
    subscribe   => [  File["/etc/zabbix/zabbix_agent.conf"], 
                      File["/etc/zabbix/zabbix_agentd.conf"], 
                      File["/etc/init.d/zabbix-agent"]],
    require     => [  Package["zabbix-agent"], 
                      File["/etc/init.d/zabbix-agent"]],
  }
}
