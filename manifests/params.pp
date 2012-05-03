class tribily::params {

  # The uri/IP of the server this agent is reporting to
  #  Default: the tribily backend
  $zabbix_server = $::tribily_zabbix_server ? {
    ''      => 'backend.tribily.com',
    default => $::tribily_zabbix_server
  }

  # The hostname used to report to the tribily server.
  #  Default: the fqdn of the host the agent is being installed on
  $host_name = $::tribily_host_name ? {
    ''      => $::fqdn,
    default => $::tribily_host_name
  }

  # The directory the configuration files for zabbix agent are read from
  #  Default: /etc/zabbix
  $conf_dir = $::tribily_conf_dir ? {
    ''      => '/etc/zabbix',
    default => $::tribily_conf_dir
  }

  $userparam_conf_dir = $::tribily_userparam_conf_dir ? {
    ''      => "$conf_dir/conf.d",
    default => $::tribily_userparam_conf_dir
  }

  # The user the agent will run as. Needs to be defined outside this module
  $agent_user = $::tribily_agent_user ? {
    ''      => 'zabbix',
    default => $::tribily_agent_user
  }

  $agent_group = $::tribily_agent_group ? {
    ''      => 'zabbix',
    default => $::tribily_agent_group
  }

  $use_unstable_tribily_repo = $::tribily_use_unstable_tribily_repo ? {
    ''      => false,
    default => $::tribily_use_unstable_tribily_repo
  }

  $use_stable_tribily_repo = $::tribily_use_stable_tribily_repo ? {
    ''      => true,
    default => $::tribily_use_stable_tribily_repo
  }

  ## The credentials to a mysql user that will do monitoring
  $monitor_mysql_user = $::tribily_monitor_mysql_user ? {
    ''      => "root",
    default => $::tribily_monitor_mysql_user,
  }

  ## The credentials to a mysql user that will do monitoring
  $monitor_mysql_pass = $::tribily_monitor_mysql_pass ? {
    ''      => "root",
    default => $::tribily_monitor_mysql_pass,
  }
}
