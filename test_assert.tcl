source assert.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

assertNumberEquals 1 1
assertStringEquals abc abc
