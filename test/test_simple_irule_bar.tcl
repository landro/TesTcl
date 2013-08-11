source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

event HTTP_REQUEST

on HTTP::uri return "/bar"

endstate pool bar

run irules/simple_irule.tcl simple
