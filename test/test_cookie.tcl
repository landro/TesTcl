package require -exact testcl 1.0.13
namespace import ::testcl::*

before {
  event HTTP_REQUEST
}

it "should store cookie as position arg" {
  event HTTP_REQUEST
  HTTP::cookie insert "testcookie" "pos"
  verify "Cookie is set" "pos" == {HTTP::cookie value "testcookie"}
  run irules/cookie_irule.tcl cookie
}

it "should only contain one cookie" {
  event HTTP_REQUEST
  verify "There should be one cookie" 1 == {HTTP::cookie count "testcookie"}
  HTTP::cookie insert "testcookie" "pos"
  run irules/cookie_irule.tcl cookie
}

it "should have a cookie with the name stored" {
  event HTTP_REQUEST
  HTTP::cookie insert "testcookie" "pos"
  verify "A cookie with the name should exist" {testcookie} == {HTTP::cookie names}
  run irules/cookie_irule.tcl cookie
}

it "should store cookie as named arg" {
  event HTTP_REQUEST
  HTTP::cookie insert name "testcook" value "named"
  verify "The cookie value should be set" "named" == {HTTP::cookie "testcook"}
  run irules/cookie_irule.tcl cookie
}

it "should store cookie directives" {
  event HTTP_REQUEST
  HTTP::cookie insert name "directive_cookie" value "directive" path "/" domain "example.com" version "1"
  verify "The directive cookie should be set" "directive" == {HTTP::cookie value "directive_cookie"}
  run irules/cookie_irule.tcl cookie
}

it "should exist" {
  event HTTP_REQUEST
  HTTP::cookie insert name "existing" value "existing" 
  verify "The cookie existing should exist(s)" true == {HTTP::cookie exists "existing"}
  run irules/cookie_irule.tcl cookie
}

it "should delete a cookie" {
  event HTTP_REQUEST
  HTTP::cookie insert name "remove_me" value "remove_me" 
  HTTP::cookie remove "remove_me"
  verify "The remove_me cookie should be removed" false == {HTTP::cookie exists "remove_me"}
  run irules/cookie_irule.tcl cookie
}
