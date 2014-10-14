source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/pool.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

on HTTP::uri return "/bar"
on pool foo return ""

run irules/simple_irule.tcl simple

trigger HTTP_REQUEST

endstate pool bar
