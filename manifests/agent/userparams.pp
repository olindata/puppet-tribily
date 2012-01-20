define tribily::agent::userparams::dummyloop {
    # Add userparam to the file
    augeas { "userparam_${name}":
      context => "/files/${tribily::params::userparam_conf_dir}/zabbix_agentd.conf",
      changes => "set 'UserParam=${name}'",
    }    
}

define tribily::agent::userparams($file_src=undef, $userparams=[]) {
  
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
      owner   => $tribily::params::agent_user,
      group   => $tribily::params::agent_user,
      source  => $file_src,
      require => User[$tribily::params::agent_user]
    }
    
  }
}