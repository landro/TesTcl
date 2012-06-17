package require log

proc assertString {expected actual} {
  if {$expected ne $actual} {
    error "Expected '$expected', got '$actual'"
  }
}

proc assertNumber {expected actual} {
  if {$expected != $actual} {
    error "Expected '$expected', got '$actual'"
  }
}

proc on {args} {
  log::log debug "on called with the following [llength $args] arguments: $args"
  global expectations
  lappend expectations $args
  
}

proc endstate {args} {
  global expectedEndState
  # TODO add more
  if { [llength $args] == 2 } {
    on [lindex $args 0] [lindex $args 1] end endstate
    set expectedEndState $args
  }
}

rename unknown ::tcl::unknown

proc unknown {args} {

  global expectations

  if { [info exists expectations] } {

    foreach expectation $expectations {

      set proccall [lrange $expectation 0 end-2]
      set procresult [lindex $expectation end]

      if { $proccall == $args} {
        switch -regexp [lindex $expectation end-1] {
          {^return$} {
            log::log info "Returning value '$procresult' for '$proccall'"
            return $procresult
          }
          {^error$} {
            log::log info "Generate error '$procresult' for '$proccall'"
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

  error "Unexpected unknown command invocation '$args'"
  # TODO?
  #uplevel ::tcl::unknown $args
}

