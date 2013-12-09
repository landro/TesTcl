source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
source src/it.tcl
source src/terminal.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
}

it "should handle request using pool bar" {
  on HTTP::uri return "/bar"
  on pool foo return ""
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should handle request using pool foo" {
  on HTTP::uri return "/foo/admin"
  on pool bar return ""
  endstate pool foo
  run irules/simple_irule.tcl simple
}

stats
