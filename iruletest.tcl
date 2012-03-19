source on.tcl
source onirule.tcl

set debugOn true

event HTTP_REQUEST

on HTTP::uri return "/foo/admin"

endstate pool foo

set rc [catch {source irule.tcl} result]

assertString "rule irule" $result
assertNumber 0 $rc