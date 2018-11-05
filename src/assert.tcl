package provide testcl 1.0.12
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
# Throws error if values don't match
proc ::testcl::assertStringEquals {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected ne $actual} {
    error "Expected '$expected', got '$actual'"
  }
}

# testcl::assertNumberEquals --
#
# Asserts that actual numeric value matches expected numeric value
#
# Arguments:
# expected The expected numeric value
# actual The actual numeric value
#
# Side Effects:
# None.
#
# Results:
# Throws error if values don't match
proc ::testcl::assertNumberEquals {expected actual} {
  log::log debug "Expecting '$expected', got actual '$actual'"
  if {$expected != $actual} {
    error "Expected '$expected', got '$actual'"
  }
}
