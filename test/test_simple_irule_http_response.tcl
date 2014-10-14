source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

run irules/simple_irule.tcl simple

trigger HTTP_RESPONSE
