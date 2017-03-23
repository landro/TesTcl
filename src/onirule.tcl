package provide testcl 1.0.10
package require log

namespace eval ::testcl {
  variable expectedEvent
  namespace export rule
  namespace export when
  namespace export event
  namespace export run
}

# testcl::rule --
#
# Override of the iRule rule command
#
# Arguments:
# ruleName The name of the rule
# body the body of the rule
#
# Side Effects:
# None.
#
# Results:
# None.
proc ::testcl::rule {ruleName body} {
  log::log debug "rule $ruleName invoked"
  set rc [catch $body result]
  log::log info "rule $ruleName finished, return code: $rc  result: $result"

  if {$rc != 2000} {
    log::log error "Expected return code 200 from calling when, got $rc"
    log::log error "Error info: $::errorInfo"
    log::log error "++++++++++++++++++++++++++++++++++++++++++"	  	  
    error "Expected return code 2000 from calling when, got $rc"
  } else {
    return "rule $ruleName"
  }
  
}

# testcl::when --
#
# Override of the iRule when command
#
# https://devcentral.f5.com/wiki/iRules.when.ashx
#
# Arguments:
# event Type of event, for instance HTTP_REQUEST
# [timing on|off] currently ignored
# [priority N] currently ignored
# body the body of the when command
#
# Side Effects:
# None.
#
# Results:
# None.
proc ::testcl::when args {
	
  # TODO add support for priority 
  if { [llength $args] != 2 && [llength $args] != 4 && [llength $args] != 6 } {
    error "wrong # args for when, expected 2, 4 or 6 args"
  } else {
    set event [lindex $args 0]
    set body [lindex $args end]
  }

  variable expectedEvent

  if {[info exists expectedEvent] && $event eq $expectedEvent} {
    log::log debug "when invoked with expected event '$event'"
    set rc [catch $body result]
    log::log info "when invoked with expected event $event finished, return code: $rc  result: $result"

    variable expectedEvent
    variable expectedEndState
    if { ![info exist expectedEndState] } {
      log::log debug "endstate verification skipped - undefined in current \"it\" context"
      if {$rc >= 1000} {
        error "Expected return code < 1000, got $rc"
      }
      return -code 2000 "when $event"
    }

    if {$rc != 1000} {
      log::log error "Expected end state with return code 3, got $rc"
      log::log error "Error info: $::errorInfo"
      log::log error "++++++++++++++++++++++++++++++++++++++++++"	  	  
      error "Expected end state with return code 3, got $rc"
    }

    if {$result ne $expectedEndState} {
      error "Expected end state $expectedEndState, got $result"
    }

    return -code 2000 "when $event"

  } elseif {[info exists expectedEvent] && $event ne $expectedEvent} {
    log::log debug "when not invoked due to non-matching event type"
  } else {
    log::log error "when not invoked due to missing expected event"
    error "when not invoked due to missing expected event"
  }

}

# testcl::event --
#
# Proc to setup the kind of event to expect
#
# Arguments:
# event_type The type of event, e.g. HTTP_REQUEST, HTTP_RESPONSE, CLIENT_ACCEPTED
#
# Side Effects:
# None.
#
# Results:
# None.

proc ::testcl::event {event_type} {
  variable expectedEvent
  set validEvents [list]
  # GLOBAL events
  lappend validEvents FLOW_INIT LB_FAILED LB_SELECTED NAME_RESOLVED PERSIST_DOWN RULE_INIT
  # HTTP events
  lappend validEvents HTTP_CLASS_FAILED HTTP_CLASS_SELECTED HTTP_DISABLED HTTP_PROXY_REQUEST HTTP_REQUEST 
  lappend validEvents HTTP_REQUEST_DATA HTTP_REQUEST_SEND HTTP_RESPONSE HTTP_RESPONSE_CONTINUE HTTP_RESPONSE_DATA 
  lappend validEvents HTTP_REQUEST_RELEASE HTTP_RESPONSE_RELEASE
  # TCP/IP events
  lappend validEvents CLIENT_ACCEPTED CLIENT_CLOSED CLIENT_DATA CLIENTSSL_DATA SERVER_CLOSED SERVER_CONNECTED 
  lappend validEvents SERVER_DATA SERVERSSL_DATA USER_REQUEST USER_RESPONSE
  if { [lsearch $validEvents "$event_type"] != -1 } {
    set expectedEvent $event_type
  } else {
    log::log error "Usupported event: $event_type. Supported events are $validEvents"
    error "Usupported event: $event_type. Supported events are $validEvents"
  }
}

# testcl::run --
#
# Run irule
#
# Arguments:
# irule the file containing the irule
# rulename the name of the rule
#
# Side Effects:
# none
#
# Results:
# none
proc ::testcl::run {irule rulename} {
  log::log info "Running irule $irule"
  set rc [catch {source $irule} result]
  if { 0 != $rc } {
    log::log error "Running irule $irule failed: $result"	  
    log::log error "Error info: $::errorInfo"
    log::log error "++++++++++++++++++++++++++++++++++++++++++"	  	  
    error "Running irule $irule failed: $result"	
  }
  testcl::assertStringEquals "rule $rulename" $result
}

proc ::testcl::call args {
  return [eval $args]
}
