source assert.tcl
namespace import ::testcl::assertNumberEquals
namespace import ::testcl::assertStringEquals

# Comment out to suppress logging
log::lvSuppressLE info 0

assertNumberEquals 1 1
assertStringEquals abc abc
