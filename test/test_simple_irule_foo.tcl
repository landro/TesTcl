source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/pool.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

on HTTP::uri return "/foo/admin"
on pool bar return ""

run irules/simple_irule.tcl simple

trigger HTTP_REQUEST

endstate pool foo
