proc when {condition body} {
  set rc [catch $body result]
  puts "when $condition finished, return code: $rc  result: $result"
  
  if {$rc != 1000} {
    error "Expected end state with return code 1000, got $rc"
  }
  
  global expectedEndState
  
  if {$result ne $expectedEndState} {
    error "Expected end state $expectedEndState, got $result"
  }
  
}