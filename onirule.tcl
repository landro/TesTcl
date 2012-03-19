proc rule {ruleName body} {
  global debugOn
  if {[info exists debugOn] } {
    puts "-rule $ruleName invoked"
  }
  set rc [catch $body result]
  if {[info exists debugOn] } {
    puts "-rule $ruleName finished, return code: $rc  result: $result"
  }

  if {$rc != 2000} {
    error "Expected return code 2000 from calling when, got $rc"
  } else {
    return "rule $ruleName"
  }
  
}

proc when {event body} {

  global expectedEvent
  global debugOn

  if {[info exists expectedEvent] && $event eq $expectedEvent} {
    if {[info exists debugOn] } {
      puts "--when invoked with expected event '$event'"
    }
    set rc [catch $body result]
    if {[info exists debugOn] } {
      puts "--when invoked with expected event $event finished, return code: $rc  result: $result"
    }
    
    if {$rc != 1000} {
      error "Expected end state with return code 1000, got $rc"
    }
    
    global expectedEndState
    
    if {$result ne $expectedEndState} {
      error "Expected end state $expectedEndState, got $result"
    }
    return -code 2000 "when $event"
  } else {
    error "--when not invoked due to missing expected event"
  }

}

proc event {event_type} {
  global expectedEvent
  if {$event_type eq "HTTP_REQUEST" || $event_type eq "HTTP_RESPONSE"} {
    set expectedEvent $event_type
  } else {
    error "Usupported event: $event_type. Supported events are HTTP_REQUEST and HTTP_RESPONSE"
  }
}