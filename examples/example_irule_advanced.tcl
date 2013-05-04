package require -exact testcl 0.9
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
  on HTTP::header insert X-Forwarded-SSL true return ""
}

it "should handle admin request using pool admin when credentials are valid" {
  on HTTP::uri return "/admin"
  on HTTP::username return "admin"
  on HTTP::password return "password"
  on HTTP::uri /admin return ""
  endstate pool pool_admin_application
  run irules/advanced_irule.tcl advanced
}

it "should ask for credentials when admin request without correct credentials" {
  on HTTP::uri return "/admin"
  on HTTP::username return "not_admin"
  on HTTP::password return "wrong_password"
  endstate HTTP::respond 401 WWW-Authenticate "Basic realm=\"Restricted Area\""
  run irules/advanced_irule.tcl advanced
}

it "should block access to uri /blocked" {
  on HTTP::uri return "/blocked"
  endstate HTTP::respond 403
  run irules/advanced_irule.tcl advanced
}

it "should give apache http client a correct error code when app pool is down" {
  on HTTP::uri return "/app"
  on active_members pool_application return 0
  on HTTP::header User-Agent return "Apache HTTP Client"
  endstate HTTP::respond 503
  run irules/advanced_irule.tcl advanced
}

it "should give other clients then apache http client redirect to fallback when app pool is down" {
  on HTTP::uri return "/app"
  on active_members pool_application return 0
  on HTTP::header User-Agent return "Firefox 13.0.1"
  endstate HTTP::redirect "http://fallback.com"
  run irules/advanced_irule.tcl advanced
}

it "should give handle app request using app pool when app pool is up" {
  on HTTP::uri return "/app"
  on HTTP::uri /app return ""
  on active_members pool_application return 2
  endstate pool pool_application
  run irules/advanced_irule.tcl advanced
}

it "should give 404 when request cannot be handled" {
  on HTTP::uri return "/cannot_be_handled"
  endstate HTTP:respond 404
  run irules/advanced_irule.tcl advanced
}

stats