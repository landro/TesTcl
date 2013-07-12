package provide testcl 0.9
package require log

namespace eval ::testcl {
  variable nbOfTestFailures 0
  variable before
  namespace export it
  namespace export before
  namespace export stats
}

# testcl::reset_expectations --
#
# Resets the expectations between specifications
#
# Arguments:
# None
#
# Side Effects:
# Resets expectations, end state, verifications and headers
#
# Results:
# None.
proc ::testcl::reset_expectations { } {
  variable expectations
  if { [info exists expectations] } {
    log::log debug "Reset expectations"
    set expectations {}
  }
  variable expectedEndState
  if { [info exists expectedEndState] } {
    log::log debug "Reset end state"
    unset expectedEndState
  }
  variable expectedEvent
  if { [info exists expectedEvent] } {
    log::log debug "Reset expected event"
    unset expectedEvent
  }
  variable verifications
  if { [info exists verifications] } {
    log::log debug "Reset expected verifications"
	set verifications {}
  }
  log::log debug "Reset HTTP headers"
  HTTP::header remove
}

# testcl::before --
#
#  that actual numeric value matches expected numeric value
#
# Arguments:
# body Body containing statements to be run before the specifications
#
# Side Effects:
# Sets before variable to contain body
#
# Results:
# None
proc ::testcl::before {body} {
  variable before
  set before $body
}

# testcl::it --
#
# Asserts that actual numeric value matches expected numeric value
#
# Arguments:
# description Description describing the specificaiton
# body Body containing statements to be run before running the iRule.
#
# Side Effects:
# None.
#
# Results:
# Prints description and either
# -> Test OK if specification is met
# -> Test failure otherwise
proc ::testcl::it {description body} {

  puts "\n**************************************************************************"
  puts "* it $description"
  puts "**************************************************************************"

  reset_expectations

  variable before
  if { [info exists before] } {
    log::log debug "Calling before"
    eval $before
  } else {
    log::log debug "No before proc"
  }

  variable nbOfTestFailures
  set rc [catch $body result]
  
  if {$rc == 0} {
    set result [::testcl::verifyEvaluate]
	if {$result ne ""} {
	  set rc 1
	}
  }
  
  if {$rc != 0 } {
    puts "-> Test failure!!"
    puts "-> -> $result"
    log::log error $result 
    incr nbOfTestFailures
  } else {
    puts "-> Test ok"
  }
  
}
# testcl::stats --
#
# Prints the number of test failures you have.
# Method call should be added at end of test file (after the it statements)
#
# Arguments:
# None
# Side Effects:
# None.
#
# Results:
# Prints test failure statistics
proc ::testcl::stats {} {
  variable nbOfTestFailures
  puts "\n\n\n"
  puts "========================================================="
  puts "  Total number of test failures: $nbOfTestFailures"
  puts "========================================================="
}
