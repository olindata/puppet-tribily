class tribily::agent::nginx {

  tribily::agent::userparams{ 'nginx':
    content       => template('tribily/nginx/nginx_userparams.conf.erb'),
  }

  file { '/opt/tribily/bin/nginx_status.sh':
    ensure  => present,
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    content => template('tribily/nginx/nginx_status.sh.erb'),
    require => File['/opt/tribily/bin']
  }
}