package require testcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

it "should modify response" {
  run test/fixtures/simple_irule.tcl simple
  trigger HTTP_RESPONSE
  verify "Vary HTTP header value should be set to Accept-Encoding" "Accept-Encoding" eq {HTTP::header Vary}
}

stats
