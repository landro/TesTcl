source on.tcl
source assert.tcl
source onirule.tcl
source it.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

it "should handle request using pool bar" {

  event HTTP_REQUEST
  
  on HTTP::uri return "/bar"
  
  endstate pool bar
  
  set rc [catch {source irule.tcl} result]
  
  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc
  
}

it "should handle request using pool foo" {

  event HTTP_REQUEST
  
  on HTTP::uri return "/foo/admin"
  
  endstate pool foo
  
  set rc [catch {source irule.tcl} result]
  
  assertStringEquals "rule irule" $result
  assertNumberEquals 0 $rc
  
}
