source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
source src/it.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

it "should modify response" {
  run irules/simple_irule.tcl simple
  trigger HTTP_RESPONSE
  verify "Vary HTTP header value should be set to Accept-Encoding" "Accept-Encoding" eq {HTTP::header Vary}
}

stats
