proc log_debug {string} {
  global debugOn
  if { [info exists debugOn] || [info exists infoOn] } {
    puts "DEBUG $string"
  }
}

proc log_info {string} {
  global infoOn
  if { [info exists infoOn] } {
    puts "INFO $string"
  }
}

