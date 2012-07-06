package require log

namespace eval ::testcl {
  variable nbOfTestFailures 0
  variable before
  namespace export it
  namespace export before
}

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
}

proc ::testcl::before {body} {
  variable before
  set before $body
}

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
  
  if {$rc != 0 } {
    puts "-> Test failure!!"
    puts "-> -> $result"
    log::log error $result 
    incr $nbOfTestFailures
  } else {
    puts "-> Test ok"
  }
  
}
