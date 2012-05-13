set nbOfTestFailures 0

proc it {description body} {
  
  # Clear out expectations
  global expectations
  if { [info exists expectations] } {
    puts "Reset expectations"
    unset expectations
  }
  global expectedEndState
  if { [info exists expectedEndState] } {
    puts "Reset end state"
    unset expectedEndState
  }
  puts "* it $description"
  puts "************************"
  global nbOfTestFailures
  set rc [catch $body result]
  
  if {$rc != 0 } {
    puts "** Test failure!!"
    incr $nbOfTestFailures
  } else {
    puts "** Test ok"
  }
  
}