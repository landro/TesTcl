package provide testcl 0.8
package require log

namespace eval ::testcl {
  variable expectations {}
  variable expectedEndState
  namespace export on
  namespace export endstate
  namespace export unknown
}

proc ::testcl::on {args} {
  log::log debug "on called with the following [llength $args] arguments: $args"
  variable expectations
  lappend expectations $args
  
}

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
  log::log error $errorMessage
  error $errorMessage
  # TODO?
  #uplevel ::tcl::unknown $args
}

