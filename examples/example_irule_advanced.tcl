package require -exact testcl 1.0.12
namespace import ::testcl::*

##
# Example demonstrating how to use TesTcl
# This is how you should write your tests
# 
# To run example
#
# export TCLLIBPATH=/parent/dir/of/this/file
#
# and run the following command from /parent/dir/of/this/file
#
# jtcl examples/example_irule_advanced.tcl
#
##

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
}

it "should handle admin request using pool admin when credentials are valid" {
  HTTP::uri "/admin"
  on HTTP::username return "admin"
  on HTTP::password return "password"
  endstate pool pool_admin_application
  run irules/advanced_irule.tcl advanced
}

it "should ask for credentials when admin request with incorrect credentials" {
  HTTP::uri "/admin"
  HTTP::header insert Authorization "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
  verify "user Aladdin" "Aladdin" eq {HTTP::username}
  verify "password 'open sesame'" "open sesame" eq {HTTP::password}
  verify "WWW-Authenticate header is 'Basic realm=\"Restricted Area\"'" "Basic realm=\"Restricted Area\"" eq {HTTP::header "WWW-Authenticate"}
  verify "response status code is 401" 401 eq {HTTP::status}
  run irules/advanced_irule.tcl advanced
}

it "should ask for credentials when admin request without credentials" {
  HTTP::uri "/admin"
  verify "WWW-Authenticate header is 'Basic realm=\"Restricted Area\"'" "Basic realm=\"Restricted Area\"" eq {HTTP::header "WWW-Authenticate"}
  verify "response status code is 401" 401 eq {HTTP::status}
  run irules/advanced_irule.tcl advanced
}

it "should block access to uri /blocked" {
  HTTP::uri "/blocked"
  endstate HTTP::respond 403
  run irules/advanced_irule.tcl advanced
}

it "should give apache http client a correct error code when app pool is down" {
  HTTP::uri "/app"
  on active_members pool_application return 0
  HTTP::header insert User-Agent "Apache HTTP Client"
  endstate HTTP::respond 503
  run irules/advanced_irule.tcl advanced
}

it "should give other clients then apache http client redirect to fallback when app pool is down" {
  HTTP::uri "/app"
  on active_members pool_application return 0
  HTTP::header insert User-Agent "Firefox 13.0.1"
  verify "response status code is 302" 302 eq {HTTP::status}
  verify "Location header is 'http://fallback.com'" "http://fallback.com" eq {HTTP::header Location}
  run irules/advanced_irule.tcl advanced
}

it "should give handle app request using app pool when app pool is up" {
  HTTP::uri "/app/form?test=query"
  on active_members pool_application return 2
  endstate pool pool_application
  verify "result uri is /form?test=query" "/form?test=query" eq {HTTP::uri}
  verify "result path is /form" "/form" eq {HTTP::path}
  verify "result query is test=query" "test=query" eq {HTTP::query}
  run irules/advanced_irule.tcl advanced
}

it "should give 404 when request cannot be handled" {
  HTTP::uri "/cannot_be_handled"
  endstate HTTP::respond 404
  run irules/advanced_irule.tcl advanced
}

stats
