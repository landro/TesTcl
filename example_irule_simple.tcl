package require -exact testcl 0.8.1
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
}

it "should handle request using pool bar" {
  on HTTP::uri return "/bar"
  endstate pool bar
  run simple_irule.tcl simple
}

it "should handle request using pool foo" {
  on HTTP::uri return "/foo/admin"
  endstate pool foo
  run simple_irule.tcl simple
}