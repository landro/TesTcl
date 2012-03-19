source tclprocmock/on.tcl
source tclprocmock/onirule.tcl

set debugOn true

event HTTP_REQUEST

on HTTP::uri return "/foo/admin"

endstate pool foo

set rc [catch {source tclprocmock/irule.tcl} result]

assertString "rule irule" $result
assertNumber 0 $rc