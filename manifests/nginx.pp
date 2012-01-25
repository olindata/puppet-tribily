
class tribily::nginx {

  $nginx_script = /usr/local/sbin/nginx_status.sh

  tribily::agent::userparams { "${name}-userparams":
    userparams => [
      "nginx.accepts,${nginx_script} accepts",
      "nginx.handled,${nginx_script} handled",
      "nginx.requests,${nginx_script} requests",
      "nginx.connections.active,${nginx_script} active",
      "nginx.connections.reading,${nginx_script} reading",
      "nginx.connections.writing,${nginx_script} writing",
      "nginx.connections.waiting,${nginx_script} waiting",

    ]
  }


  file { $nginx_script:
    ensure => 'present',
    source => 'puppet:///tribily/nginx_status.sh',
    mode   => 755,
  }

}
