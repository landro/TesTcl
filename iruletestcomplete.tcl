source on.tcl
source onirule.tcl
source it.tcl

# Comment out to suppress logging
log::lvSuppressLE info 0

it "should handle request using pool bar" {

  event HTTP_REQUEST
  
  on HTTP::uri return "/bar"
  
  endstate pool bar
  
  set rc [catch {source irule.tcl} result]
  
  assertString "rule irule" $result
  assertNumber 0 $rc
  
}

it "should handle request using pool foo" {

  event HTTP_REQUEST
  
  on HTTP::uri return "/foo/admin"
  
  endstate pool foo
  
  set rc [catch {source irule.tcl} result]
  
  assertString "rule irule" $result
  assertNumber 0 $rc
  
}
