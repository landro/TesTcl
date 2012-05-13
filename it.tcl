source logging.tcl

set nbOfTestFailures 0

proc reset_expectations { } {
  global expectations
  if { [info exists expectations] } {
    log_debug "Reset expectations"
    unset expectations
  }
  global expectedEndState
  if { [info exists expectedEndState] } {
    log_debug "Reset end state"
    unset expectedEndState
  }
}


proc it {description body} {

  reset_expectations
  
  puts "**************************************************************************"
  puts "* it $description"
  puts "**************************************************************************"
  global nbOfTestFailures
  set rc [catch $body result]
  
  if {$rc != 0 } {
    puts "** Test failure!!"
    incr $nbOfTestFailures
  } else {
    puts "** Test ok"
  }
  
}