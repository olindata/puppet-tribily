define tribily::agent::userparam($userparam) {
  
  $file = "$tribily::params::conf_dir/conf.d/$name.conf"
  
  augeas { "userparam_$name":
    context => "/files/$file",
    changes => "set 'UserParam=$userparam'",
  }
}