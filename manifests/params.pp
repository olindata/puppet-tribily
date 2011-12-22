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
  
}
