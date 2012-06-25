package require log

namespace eval ::testcl {
  namespace export assertString
  namespace export assertNumber
}

proc ::testcl::assertString {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected ne $actual} {
    error "Expected '$expected', got '$actual'"
  }
}

proc ::testcl::assertNumber {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected != $actual} {
    error "Expected '$expected', got '$actual'"
  }
}