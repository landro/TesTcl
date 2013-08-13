source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
source src/it.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
HTTP::debug
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
  on HTTP::uri return "/blocked"
  endstate HTTP::respond 403
  run irules/advanced_irule.tcl advanced
}

it "should give apache http client a correct error code when app pool is down" {
  on HTTP::uri return "/app"
  on active_members pool_application return 0
  HTTP::header insert User-Agent "Apache HTTP Client"
  endstate HTTP::respond 503
  run irules/advanced_irule.tcl advanced
}

it "should give other clients then apache http client redirect to fallback when app pool is down" {
  on HTTP::uri return "/app"
  on active_members pool_application return 0
  HTTP::header insert User-Agent "Firefox 13.0.1"
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
  endstate HTTP::respond 404
HTTP::debug
  run irules/advanced_irule.tcl advanced
HTTP::debug
}

stats
