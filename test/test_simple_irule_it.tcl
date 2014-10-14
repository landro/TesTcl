source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
source src/it.tcl
source src/pool.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  run irules/simple_irule.tcl simple
}

it "should handle request using pool bar" {
  on HTTP::uri return "/bar"
  on pool foo return ""
  trigger HTTP_REQUEST
  endstate pool bar
}

it "should handle request using pool foo" {
  on HTTP::uri return "/foo/admin"
  on pool bar return ""
  endstate pool foo
  trigger HTTP_REQUEST
}

stats
