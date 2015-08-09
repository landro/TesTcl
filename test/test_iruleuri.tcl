source src/iruleuri.tcl
source src/assert.tcl

namespace import ::testcl::*
namespace import ::testcl::URI::*

# Comment out to suppress logging
log::lvSuppressLE info 0

#test encoding
assertStringEquals "test" [encode test]

#assertStringEquals "hi%20there" [encode "hi there"]
assertStringEquals "my%20URL%20encoded%20parameter%20value%20with%20metacharacters%20(%26*%40%23%5b%5d)" [encode "my URL encoded parameter value with metacharacters (&*@#[])"]