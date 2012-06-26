package require log

namespace eval ::testcl {
  variable nbOfTestFailures 0
  namespace export it
}

proc ::testcl::reset_expectations { } {
  variable expectations
  if { [info exists expectations] } {
    log::log debug "Reset expectations"
    unset expectations
  }
  variable expectedEndState
  if { [info exists expectedEndState] } {
    log::log debug "Reset end state"
    unset expectedEndState
  }
}


proc ::testcl::it {description body} {

  ::testcl::reset_expectations
  
  puts "\n**************************************************************************"
  puts "* it $description"
  puts "**************************************************************************"
  
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