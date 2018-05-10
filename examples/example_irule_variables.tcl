rule simple {

  when HTTP_REQUEST priority 100 {
    # set variable outside irule
    if { $status eq 1 }
      pool foo
    } else {
      pool bar
    }
  }
}
