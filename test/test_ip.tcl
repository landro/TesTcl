source src/ip.tcl
source src/assert.tcl

namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

assertNumberEquals [::testcl::IP::addr "1.2.3.4" equals "1.2.3.4/24"] 1
assertNumberEquals [::testcl::IP::addr "1.2.5.4" equals "1.2.3.4/24"] 0
assertNumberEquals [::testcl::IP::addr "1.2.3.4/24" equals "1.2.3.4"] 1
assertNumberEquals [::testcl::IP::addr "1.2.5.4/24" equals "1.2.3.4"] 0
