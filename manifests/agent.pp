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
class tribily::agent {

  include tribily::params

  if $tribily::params::use_unstable_tribily_repo {
    include apt::repo::tribilytesting
    $package_name = 'tribily-agent'
  } else {
    if $tribily::params::use_stable_tribily_repo {
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
  file { "$tribily::params::conf_dir/zabbix_agent.conf":
    ensure  => present,
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    content => template("tribily/zabbix_agent.conf.erb"),
    require => Package["zabbix-agent"],
  }

  group {$tribily::params::agent_group:
    ensure  => present,
  }

  user { $tribily::params::agent_user:
    ensure  => present,
    gid     => $tribily::params::agent_group,
    require => Group[$tribily::params::agent_group]
  }

  file { $tribily::params::conf_dir:
    ensure  => directory,
    mode    => 0644,
    owner   => $tribily::params::agent_user,
    group   => $tribily::params::agent_group,
    require => [
      User[$tribily::params::agent_user],
      Group[$tribily::params::agent_group]
    ],
  }

  file { $tribily::params::userparam_conf_dir:
    ensure  => directory,
    mode    => 0644,
    owner   => $tribily::params::agent_user,
    group   => $tribily::params::agent_group,
    require => [
      User[$tribily::params::agent_user],
      Group[$tribily::params::agent_group]
    ],
  }


  # install the zabbix_agentd.conf file
  file { "$tribily::params::conf_dir/zabbix_agentd.conf":
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
    owner   => $tribily::params::agent_user,
    group   => $tribily::params::agent_group,
    require => [
      User[$tribily::params::agent_user],
      Group[$tribily::params::agent_group]
    ],
  }

  file { "/var/log/zabbix-agent":
    ensure  => directory,
    mode    => 0644,
    owner   => $tribily::params::agent_user,
    group   => $tribily::params::agent_group,
    require => [
      User[$tribily::params::agent_user],
      Group[$tribily::params::agent_group]
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
      File["$tribily::params::conf_dir/zabbix_agent.conf"],
      File["$tribily::params::conf_dir/zabbix_agentd.conf"],
      File["/etc/init.d/zabbix-agent"],
    ],
    require     => [
      Package["zabbix-agent"],
      File["/etc/init.d/zabbix-agent"],
      User[$tribily::params::agent_user],
      Group[$tribily::params::agent_group],
    ],
  }
}
