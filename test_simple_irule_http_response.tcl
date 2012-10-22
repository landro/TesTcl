source on.tcl
source assert.tcl
source onirule.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

event HTTP_RESPONSE

on HTTP::header remove "Vary" return ""
on HTTP::header insert Vary "Accept-Encoding" return ""

run simple_irule.tcl simple