## TODO all wrong!!


proc log_debug { string } {
  global debugOn
  global infoOn
  global errorOn
  if { [info exists debugOn] || [info exists infoOn] || [info exists errorOn] } {
    puts "DEBUG $string"
  }
}

proc log_info { string } {
  global debugOn
  global infoOn
  if { [info exists debugOn] || [info exists infoOn] } {
    puts "INFO $string"
  }
}

proc log_error { string } {
  global errorOn
  if { [info exists errorOn] } {
    puts "ERROR $string"
  }
}