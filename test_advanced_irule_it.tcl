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