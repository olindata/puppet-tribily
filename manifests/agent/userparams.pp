define tribily::agent::userparams::dummyloop {
    # Add userparam to the file
    augeas { "userparam_${name}":
      context => "/files/${tribily::params::userparam_conf_dir}/zabbix_agentd.conf",
      changes => "set 'UserParam=${name}'",
    }    
}

define tribily::agent::userparams($file_src=undef, $userparams=[], username='tribilyagent', password='1f0rgOtit' ) {
  
  # Check userparam for valid value
  if (($userparams == []) and ($file_src == undef)) {
    fail "$file_src and $userparams[] cannot both be empty for tribily::agent::userparam[${name}]"
  }
  
  if ($file_src == undef) {

    # run the userparams through a dummy loop to get them to be created
    reprepro::repo::dummyloop { $userparams: }
    
  } else {
    
    file{ "${tribily::params::userparam_conf_dir}/${name}.conf":
      ensure  => 'present',
      mode    => 0640,
      owner   => $tribily::params::agent_user,
      group   => $tribily::params::agent_user,
      content  => template($file_src),
      require => [
        User[$tribily::params::agent_user],
        File[$tribily::params::userparam_conf_dir],
      ],
      notify  => Service["zabbix-agent"]
    }
    
  }
}
