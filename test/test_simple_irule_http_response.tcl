source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

event HTTP_RESPONSE

on HTTP::header remove "Vary" return ""
on HTTP::header insert Vary "Accept-Encoding" return ""

run irules/simple_irule.tcl simple