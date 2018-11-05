source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

event HTTP_REQUEST

on pool bar return ""

endstate pool foo

array set variables { status 1 }
run irules/variables_irule.tcl simple variables
