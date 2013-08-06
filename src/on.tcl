package provide testcl 0.9
package require log

namespace eval ::testcl {
  variable expectations {}
  variable expectedEndState
  variable verifications {}
  namespace export on
  namespace export endstate
  namespace export verify
  namespace export unknown
  namespace export expected
}

# testcl::on --
#
# Proc to setup expectations/mocks
#
# Arguments:
# args Any number of arguments
#
# Side Effects:
# Adds expectations to list of existing expectations
#
# Results:
# None.
proc ::testcl::on {args} {
  log::log debug "on called with the following [llength $args] arguments: $args"
  variable expectations
  lappend expectations $args
}

# testcl::endstate --
#
# Proc to setup endstate
#
# Arguments:
# args  any number of arguments
#
# Side Effects:
# Adds expectation about endstate.
#
# Results:
# None.
proc ::testcl::endstate {args} {
  log::log debug "endstate called with args: $args"
  variable expectedEndState
  if { [llength $args] == 2 } {
    on [lindex $args 0] [lindex $args 1] end endstate
  } elseif { [llength $args] == 3 } {
    on [lindex $args 0] [lindex $args 1] [lindex $args 2] end endstate
  } elseif { [llength $args] == 4 } {
    on [lindex $args 0] [lindex $args 1] [lindex $args 2] [lindex $args 3] end endstate
  } elseif { [llength $args] == 5 } {
    on [lindex $args 0] [lindex $args 1] [lindex $args 2] [lindex $args 3] [lindex $args 4] end endstate
  } else {
    set errorMessage "Too many ([llength $args]) arguments for edstate: '$args'"
    log::log error $errorMessage
    error $errorMessage
  }
  set expectedEndState $args
}

# testcl::verify --
#
# Proc to setup verification required after iRule evaluation
#
# Arguments:
# description Description of verification
# result Result to compare with outcome from verification body evaluation
# condition Comparison operator
# body Verification code to evaluate
#
# Side Effects:
# None.
#
# Results:
# None.
proc ::testcl::verify {description result condition body} {
  log::log debug "verify called with args: $description $result $condition $body"
  variable verifications
  lappend verifications [list $description $result $condition $body]
}

# testcl::verifyEvaluate --
#
# Proc to evaluate all registered verifications after iRule execution
# for intenal usage in tectcl package (excluded from namespace export)
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# Error message on verification failure.
proc ::testcl::verifyEvaluate {} {
  log::log debug "verify evaluate called"
  variable verifications
  foreach verification $verifications {
    log::log debug "verification of '$verification'"
    lassign $verification description result condition body
    set rc [catch $body res]
    if {$rc != 0} {
      set errorMessage "Unexpected error during invocation of \"verify '$description'\": rc=$rc, res=$res"
      puts "\n$errorMessage\n"
      puts "You should fix a body of an \"verify\" statement in your \"it\" block:\n"
      puts "\{\n"
      puts "$body"
      puts "\}\n"
      error $errorMessage
    }
    if { ![expr "{$result} $condition {$res}"] } {
      return "Verification '$description' failed - expression: {$result} $condition {$res}"
    }
	puts "verification of '$description' done."
  }
}

rename unknown ::tcl::unknown

# testcl::unknown --
#
# Override of the unknown proc used to provide mocking.
# Values returned by this method have to be set up using
# the on proc
#
# Arguments:
# Any
#
# Side Effects:
# None
#
# Results:
# Whatever your expectation says
proc ::testcl::unknown {args} {

  log::log debug "unknown called with args: $args"

  #set rc [catch { return [::testcl::expected {*}$args] } res]
  set rc [catch { return [eval ::testcl::expected $args] } res]
  if {$rc != 1100} {
    log::log debug "rc from expected: $rc"
    if {$rc == 1000} {
      return -code 1000 $res
    }
    return $res
  }
  
  set errorMessage "Unexpected unknown command invocation '$args'"
  puts "\n$errorMessage\n"
  puts "Maybe you should add an \"on\" statement similar to the one below to your \"it\" block?\n"
  puts "    it \"your description\" \{"
  puts "      ..."
  puts "      on $args return \"your return value\""
  puts "      ..."
  puts "    \}\n"
  error $errorMessage
  # TODO?
  #uplevel ::tcl::unknown $args
}

# testcl::expected --
#
# verify if there is mock available for command
#
# Arguments:
# Any
#
# Side Effects:
# None
#
# Results:
# Whatever your expectation says
proc ::testcl::expected {args} {

  log::log debug "expected called with args: $args"
  variable expectations

  if { [llength $expectations] > 0 } {

    foreach expectation $expectations {

      set proccall [lrange $expectation 0 end-2]
      set procresult [lindex $expectation end]

      if { $proccall == $args} {
        switch -regexp [lindex $expectation end-1] {
          {^return$} {
            log::log info "Returning value '$procresult' for procedure call '$proccall'"
            return $procresult
          }
          {^error$} {
            log::log info "Generate error '$procresult' for procedure call'$proccall'"
            error $procresult
          }
          {^end$} {
            log::log info "Hitting end state '$proccall'"
            return -code 1000 $proccall
          }
          default {
            error "Invalid expectation - expected one of return, error or end."
          }
        }
      }
      
    }

  }
  return -code 1100 "expectation not found"
}
