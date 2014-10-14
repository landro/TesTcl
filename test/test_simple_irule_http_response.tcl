package require testcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

it "should call event" {
  run test/fixtures/simple_irule.tcl simple

  trigger HTTP_RESPONSE
}
