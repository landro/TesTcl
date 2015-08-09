source src/global.tcl
source src/assert.tcl

namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

assertStringEquals [getfield "foo:bar" "|" 0] ""
assertStringEquals [getfield "foo:bar" ":" 0] ""
assertStringEquals [getfield "foo:bar" ":" 1] "foo"
assertStringEquals [getfield "foo:bar" ":" 2] "bar"
assertStringEquals [getfield "foo:bar" ":" 3] ""
