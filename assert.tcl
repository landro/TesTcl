package require log

proc assertString {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected ne $actual} {
    error "Expected '$expected', got '$actual'"
  }
}

proc assertNumber {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected != $actual} {
    error "Expected '$expected', got '$actual'"
  }
}