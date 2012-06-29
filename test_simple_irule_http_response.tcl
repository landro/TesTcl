source on.tcl
source assert.tcl
source onirule.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

event HTTP_RESPONSE

# TODO fails 

run simple_irule.tcl rc result

assertStringEquals "rule irule" $result
assertNumberEquals 0 $rc