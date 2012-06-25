source assert.tcl
namespace import ::testcl::assertNumber
namespace import ::testcl::assertString

# Comment out to suppress logging
log::lvSuppressLE info 0

assertNumber 1 1
assertString abc abc