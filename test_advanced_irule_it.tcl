source on.tcl
source assert.tcl
source onirule.tcl
source it.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

it "should handle request using pool admin when credentials are ok" {

  event HTTP_REQUEST
  
  on HTTP::header insert X-Forwarded-SSL true return ""
  on HTTP::uri return "/admin"
  on HTTP::username return "admin"
  on HTTP::password return "password"
  on HTTP::uri /admin return ""
  
  endstate pool pool_admin_application
  
  set rc [catch {source advanced_irule.tcl} result]
  
  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc
  
}


