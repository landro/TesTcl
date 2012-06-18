source on.tcl
source assert.tcl
source onirule.tcl

# Comment out to suppress logging
log::lvSuppressLE info 0

event HTTP_RESPONSE

# TODO feiler 

set rc [catch {source irule.tcl} result]

assertString "rule irule" $result
assertNumber 0 $rc