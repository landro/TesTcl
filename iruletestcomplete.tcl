source on.tcl
source onirule.tcl

set debugOn true

set nbOfTestFailures 0

proc it {description body} {
  global nbOfTestFailures
  set rc [catch $body result]
  
  if {$rc != 0 } {
    puts "Test failure"
    incr $nbOfTestFailures
  } else {
    puts "Test ok"
  }
  
}

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
