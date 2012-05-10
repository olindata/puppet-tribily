define tribily::agent::userparams::dummyloop {
    # Add userparam to the file
    augeas { "userparam_${name}":
      context => "/files/${tribily::params::userparam_conf_dir}/zabbix_agentd.conf",
      changes => "set 'UserParam=${name}'",
      notify  => Service['zabbix-agent']
    }
}

define tribily::agent::userparams($source=undef, $userparams=[], $content=undef) {

  include tribily::params

  # Check userparam for valid value
  if (($userparams == []) and ($source == undef) and ($content == undef)) {
    fail "${source}, ${content} and ${userparams}[] cannot all be empty for tribily::agent::userparam[${name}]"
  }

  if ($source != undef) {
    file{ "${tribily::params::userparam_conf_dir}/${name}.conf":
      ensure  => 'present',
      mode    => 0640,
      owner   => $tribily::params::agent_user,
      group   => $tribily::params::agent_user,
      source  => $source,
      require => [
        User[$tribily::params::agent_user],
        File[$tribily::params::userparam_conf_dir],
      ],
      notify  => Service['zabbix-agent']
    }
  }

  if ($userparams != []) {
    # run the userparams through a dummy loop to get them to be created
    tribily::agent::userparams::dummyloop { $userparams: }

  }

  if ($content != undef) {
    file { "${tribily::params::userparam_conf_dir}/${name}.conf":
      ensure  => 'present',
      mode    => 0640,
      owner   => $tribily::params::agent_user,
      group   => $tribily::params::agent_user,
      content => $content,
      require => [
        User[$tribily::params::agent_user],
        File[$tribily::params::userparam_conf_dir],
      ],
      notify  => Service['zabbix-agent']
    }
  }
}
