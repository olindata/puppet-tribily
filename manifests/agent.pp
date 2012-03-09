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
class tribily::agent(
  $use_unstable_tribily_repo  = $tribily::params::use_unstable_tribily_repo,
  $use_stable_tribily_repo    = $tribily::params::use_stable_tribily_repo,
  $confdir                    = $tribily::params::conf_dir,
  $agent_group                = $tribily::params::agent_group,
  $agent_user                 = $tribily::params::agent_user,
  $userparam_conf_dir         = $tribily::params::userparam_conf_dir
) inherits tribily::params {

  if $use_unstable_tribily_repo {
    include apt::repo::tribilytesting
    $package_name = 'tribily-agent'
  } else {
    if $use_stable_tribily_repo {
      include apt::repo::tribily
      $package_name = 'tribily-agent'
    } else {
      $package_name = 'zabbix-agent'
      # the version in Debian Lenny is 1.4.7, which is too old and buggy
      if $::lsbdistcodename == 'lenny' {
        include apt::repo::lennybackports
      }
    }
  }

  # install zabbix agent.  This requires that the zabbix package
  package { "zabbix-agent":
    ensure    => "present",
    name      => $package_name
  }

  # install the zabbix_agent.conf file
  file { "${confdir}/zabbix_agent.conf":
    ensure  => present,
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    content => template("tribily/zabbix_agent.conf.erb"),
    require => Package["zabbix-agent"],
  }

  group {$agent_group:
    ensure  => present,
  }

  user { $agent_user:
    ensure  => present,
    gid     => $tribily::params::agent_group,
    require => Group[$tribily::params::agent_group]
  }

  file { $confdir:
    ensure  => directory,
    mode    => 0644,
    owner   => $agent_user,
    group   => $agent_group,
    require => [
      User[$agent_user],
      Group[$agent_group]
    ],
  }

  file { $userparam_conf_dir:
    ensure  => directory,
    mode    => 0644,
    owner   => $agent_user,
    group   => $agent_group,
    require => [
      User[$agent_user],
      Group[$agent_group]
    ],
  }


  # install the zabbix_agentd.conf file
  file { "$confdir/zabbix_agentd.conf":
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
    owner   => $agent_user,
    group   => $agent_group,
    require => [
      User[$agent_user],
      Group[$agent_group]
    ],
  }

  file { "/var/log/zabbix-agent":
    ensure  => directory,
    mode    => 0644,
    owner   => $agent_user,
    group   => $agent_group,
    require => [
      User[$agent_user],
      Group[$agent_group]
    ],
  }

  # Ensure the correct puppet.conf file is installed
  file { "/etc/init.d/zabbix-agent":
    ensure  => present,
    mode    => 0755,
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///tribily/zabbix-agent-init",
    require => Package["zabbix-agent"]
  }

  # ensure that the zabbix-agent is running
  service { "zabbix-agent":
    ensure      => running,
    enable      => true,
    status      => "/etc/init.d/zabbix-agent status",
    hasrestart  => true,
    hasstatus   => false,
    subscribe   => [
      File["$confdir/zabbix_agent.conf"],
      File["$confdir/zabbix_agentd.conf"],
      File["/etc/init.d/zabbix-agent"],
    ],
    require     => [
      Package["zabbix-agent"],
      File["/etc/init.d/zabbix-agent"],
      User[$agent_user],
      Group[$agent_group],
    ],
  }
}
