class tribily::nginx {

  $nginx_script = '/usr/local/sbin/nginx_status.sh'

  file{ "${tribily::params::userparam_conf_dir}/nginx.conf":
    ensure  => 'present',
    mode    => 0640,
    owner   => $tribily::params::agent_user,
    group   => $tribily::params::agent_user,
    content => 
      "nginx.accepts,${nginx_script} accepts
nginx.handled,${nginx_script} handled
nginx.requests,${nginx_script} requests
nginx.connections.active,${nginx_script} active
nginx.connections.reading,${nginx_script} reading
nginx.connections.writing,${nginx_script} writing
nginx.connections.waiting,${nginx_script} waiting",
    require => [
      User[$tribily::params::agent_user],
      File[$tribily::params::userparam_conf_dir],
    ],
    notify  => Service["zabbix-agent"]
  }


  file { $nginx_script:
    ensure => 'present',
    source => 'puppet:///tribily/nginx_status.sh',
    mode   => 755,
  }

}
