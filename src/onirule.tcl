package provide testcl 1.0.6
package require log

namespace eval ::testcl {
  variable expectedEvent
  namespace export rule
  namespace export when
  namespace export event
  namespace export run

  variable procedures [dict create]
  dict set procedures FLOW_INIT { }
  dict set procedures LB_FAILED { }
  dict set procedures LB_SELECTED { }
  dict set procedures NAME_RESOLVED { }
  dict set procedures PERSIST_DOWN { }
  dict set procedures RULE_INIT { }
  # HTTP procedures
  dict set procedures HTTP_CLASS_FAILED { }
  dict set procedures HTTP_CLASS_SELECTED { }
  dict set procedures HTTP_DISABLED { }
  dict set procedures HTTP_PROXY_REQUEST { }
  dict set procedures HTTP_REQUEST { }
  dict set procedures HTTP_REQUEST_DATA { }
  dict set procedures HTTP_REQUEST_SEND { }
  dict set procedures HTTP_RESPONSE { }
  dict set procedures HTTP_RESPONSE_CONTINUE { }
  dict set procedures HTTP_RESPONSE_DATA { }
  dict set procedures HTTP_REQUEST_RELEASE { }
  dict set procedures HTTP_RESPONSE_RELEASE { }
  # TCP/IP procedures { }
  dict set procedures CLIENT_ACCEPTED { }
  dict set procedures CLIENT_CLOSED { }
  dict set procedures CLIENT_DATA { }
  dict set procedures CLIENTSSL_DATA { }
  dict set procedures SERVER_CLOSED { }
  dict set procedures SERVER_CONNECTED { }
  dict set procedures SERVER_DATA { }
  dict set procedures SERVERSSL_DATA { }
  dict set procedures USER_REQUEST { }
  dict set procedures USER_RESPONSE { }
}

proc ::testcl::call {fn} {
  set rc [catch { namespace eval ::testcl $fn } result]
  if { $rc != 0 } {
    log::log error "ERROR: $rc"
    log::log error $fn
    log::log error $result
  } else {
    return $result
  }
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
proc ::testcl::rule {ruleName fn} {
  log::log debug "rule $ruleName invoked"
  call $fn
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
  variable procedures
  if { [llength $args] != 2 && [llength $args] != 4 && [llength $args] != 6 } {
    error "wrong # args for when, expected 2, 4 or 6 args"
  } else {
    set event [lindex $args 0]
    set body [lindex $args end]
  }

  if { [dict exists $procedures $event] } {
    set lst [dict get $procedures $event]
    lappend lst $body
    dict set procedures $event $lst
  } else {
    log::log error "event $event not supported"
  }
}

proc ::testcl::trigger {event args} {
  variable procedures
  set lst [dict get $procedures $event]
  foreach fn $lst {
    call $fn
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

proc ::testcl::event {event {method}} {
  variable procedures
  if { $method == "disable" } {
    log::log error "disabled event: $event"
    dict unset procedures $event
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
  set fn "source $irule"
  call $fn
}
