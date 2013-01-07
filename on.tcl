package provide testcl 0.8.2
package require log

namespace eval ::testcl {
  variable expectations {}
  variable expectedEndState
  namespace export on
  namespace export endstate
  namespace export unknown
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

