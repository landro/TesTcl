rule classes {
	
  when HTTP_REQUEST {
    if { [class match [IP::remote_addr] eq blacklist] } {
      drop
    } else {
      pool main-pool
    }
  }
	
}