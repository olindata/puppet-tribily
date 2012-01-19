define tribily::agent::userparam($file=undef, $userparam) {
  
  # Check userparam for valid value
  if ($userparam == '') {
    fail "userparam cannot be empty for tribily::agent::userparam[$name]"
  }
  
  # Check $file param and set real_file to file we want to check
  if ($file == undef) {
    $real_file = "${tribily::params::userparam_conf_dir}/zabbix_agentd.conf"
  } else {
    $real_file = $file
  }
  
  # Add userparam to the file
  augeas { "userparam_$name":
    context => "/files/$real_file",
    changes => "set 'UserParam=$userparam'",
  }
}