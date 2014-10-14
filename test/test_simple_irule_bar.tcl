package require testcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

it "should call event" {
  on HTTP::uri return "/bar"
  on pool foo return ""

  run test/fixtures/simple_irule.tcl simple

  trigger HTTP_REQUEST

  endstate pool bar
}
