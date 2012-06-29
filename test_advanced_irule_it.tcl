source on.tcl
source assert.tcl
source onirule.tcl
source it.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

it "should handle admin request using pool admin when credentials are valid" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/admin"
  on HTTP::username return "admin"
  on HTTP::password return "password"
  on HTTP::uri /admin return ""

  endstate pool pool_admin_application

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}

it "should ask for credentials when admin request without correct credentials" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/admin"
  on HTTP::username return "not_admin"
  on HTTP::password return "wrong_password"

  endstate HTTP::respond 401 WWW-Authenticate "Basic realm=\"Restricted Area\""

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}

it "should block access to uri /blocked" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/blocked"

  endstate HTTP::respond 403

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}

it "should give apache http client a correct error code when app pool is down" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/app"
  on active_members pool_application return 0
  on HTTP::header User-Agent return "Apache HTTP Client"

  endstate HTTP::respond 503

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}

it "should give other clients then apache http client redirect to fallback when app pool is down" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/app"
  on active_members pool_application return 0
  on HTTP::header User-Agent return "Firefox 13.0.1"

  endstate HTTP::redirect "http://fallback.com"

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}

it "should give handle app request using app pool when app pool is up" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/app"
  on HTTP::uri /app return ""
  on active_members pool_application return 2

  endstate pool pool_application

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}

it "should give 404 when request cannot be handled" {

  event HTTP_REQUEST

  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/cannot_be_handled"

  endstate HTTP:respond 404

  run advanced_irule.tcl rc result

  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc

}