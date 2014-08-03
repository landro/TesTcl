rule simple_chain {

  when CLIENT_ACCEPTED {
    set orig_port "[TCP::local_port]"
  }

  when HTTP_REQUEST {
    # Set x-forwarded-port Header
    if {[info exists orig_port]} {
	    puts "yo"
      if { [HTTP::header exists "x-forwarded-port"] } {
	HTTP::header replace "x-forwarded-port" "$orig_port"
      } else {
	HTTP::header insert "x-forwarded-port" "$orig_port"
      }
    }
  }

}
