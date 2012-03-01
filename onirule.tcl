proc when {condition body} {
  set rc [catch $body result]
  puts "when $condition finished, return code: $rc  result: $result"

  if {$rc != 2} {
    return -code error "Expected end state with return code 'TCL_RETURN(2)'"
  }
  
  set expectedEndState [endstate]
  
  if {$result ne $expectedEndState} {
    return -code error "Expected end state $expectedEndState, got $result"
  }
  
}