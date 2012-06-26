package require log

namespace eval ::testcl {
  namespace export assertStringEquals
  namespace export assertNumberEquals
}

# testcl::assertStringEquals --
#
# Asserts that actual string value matches expected string value
#
# Arguments:
# expected The expected string value
# actual The actual string value
#
# Side Effects:
# None.
#
# Results:
# Returns error if values don't match
proc ::testcl::assertStringEquals {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected ne $actual} {
    error "Expected '$expected', got '$actual'"
  }
}

proc ::testcl::assertNumberEquals {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected != $actual} {
    error "Expected '$expected', got '$actual'"
  }
}