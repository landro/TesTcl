source on.tcl
source onirule.tcl

set debugOn true

event HTTP_RESPONSE

# TODO feiler 

set rc [catch {source irule.tcl} result]

assertString "rule irule" $result
assertNumber 0 $rc